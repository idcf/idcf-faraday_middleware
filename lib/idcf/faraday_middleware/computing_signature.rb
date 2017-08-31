module Idcf
  module FaradayMiddleware
    # コンピューティング用のシグネチャ生成を実施します。
    class ComputingSignature < Faraday::Middleware
      include FaradayMiddleware::Configuration
      include FaradayMiddleware::Validations

      class_attribute :api_key, :secret_key

      def initialize(app, keys = {})
        super(app)
        @api_key    = keys[:api_key]
        @secret_key = keys[:secret_key]
      end

      def call(env)
        raise InvalidKeys, errors.messages.to_s if invalid?

        query = env.url.query
        query = add_query_param query, 'apikey',    api_key
        query = add_query_param query, 'response',  'json'
        query = add_query_param query, 'signature', signature(env)
        env.url.query = query

        @app.call env
      end

      private

      def add_query_param(query, key, value)
        query = query.to_s
        query << '&' unless query.empty?
        query << "#{Faraday::Utils.escape key}=#{Faraday::Utils.escape value}"
      end

      def signature(env)
        Base64.strict_encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest::SHA1.new,
            secret_key,
            signature_seed(env)
          )
        )
      end

      def signature_seed(env)
        query = env.url.query&.downcase
        raise InvalidParameter, 'Must be set command=...' if query.nil?
        query = URI.decode_www_form(query)
        command_check query
        query.sort! { |x, y| x[0] <=> y [0] }
        URI.encode_www_form(query).gsub('+', '%20').downcase
      end

      def command_check(query)
        raise InvalidParameter, 'Must be set command=...' if
          query.find { |x| x[0] == 'command' && x[1].present? }.nil?
      end
    end
  end
end
