module Idcf
  module FaradayMiddleware
    # ILB, DNS, Your(Billing)用のシグネチャ生成を実施します。
    class Signature < Faraday::Middleware
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

        env[:request_headers][HEADER_API_KEY]   = api_key
        env[:request_headers][HEADER_EXPIRES]   = expires
        env[:request_headers][HEADER_SIGNATURE] = signature env

        @app.call env
      end

      private

      def signature(env)
        Base64.strict_encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest::SHA256.new,
            secret_key,
            signature_seed(env)
          )
        )
      end

      def signature_seed(env)
        [
          env.method.to_s.upcase,
          env.url.path,
          api_key,
          env[:request_headers][HEADER_EXPIRES],
          env.url.query.to_s.gsub('+', '%20')
        ].join("\n")
      end

      def expires
        (Time.now.to_i + SIGNATURE_TTL).to_s
      end
    end
  end
end
