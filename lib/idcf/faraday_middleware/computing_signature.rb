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

        if env.body.nil?
          env.url.query = make_get_params(env)
        else
          env.body = make_params_body(env)
        end
        @app.call env
      end

      private

      def make_params_body(env)
        params = URI.decode_www_form(env.url.query)
        params.concat(URI.decode_www_form(env.body))
        params << ['apikey', api_key]
        params << %w(response json)
        params << ['signature', signature(URI.encode_www_form(params))]
        URI.encode_www_form(params)
      end

      def make_get_params(env)
        query = env.url.query
        query = add_query_param query, 'apikey', api_key
        query = add_query_param query, 'response', 'json'
        add_query_param query, 'signature', signature(query)
      end

      def add_query_param(query, key, value)
        query = query.to_s
        query << '&' unless query.empty?
        query << "#{Faraday::Utils.escape key}=#{Faraday::Utils.escape value}"
      end

      def signature(query)
        Base64.strict_encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest::SHA1.new,
            secret_key,
            signature_seed(query)
          )
        )
      end

      def signature_seed(query)
        raise InvalidParameter, 'Must be set command=...' if query.nil?
        query = URI.decode_www_form(query.downcase)
        command_check query
        query = query.sort do |x, y|
          x[0] <=> y[0]
        end
        signeture_seed_part_decode(URI.encode_www_form(query)).downcase
      end

      def signeture_seed_part_decode(query)
        PARTIALLY_DECODE.each do |list|
          query = query.gsub(*list)
        end
        query
      end

      def command_check(query)
        list = query.find do |x|
          x[0] == 'command' && x[1].present?
        end
        raise InvalidParameter, 'Must be set command=...' if list.nil?
      end
    end
  end
end
