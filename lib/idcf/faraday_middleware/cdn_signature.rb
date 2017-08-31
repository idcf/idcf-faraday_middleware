module Idcf
  module FaradayMiddleware
    # コンテンツキャッシュ用のシグネチャ生成を実施します。
    class CdnSignature < Signature
      def call(env)
        raise InvalidKeys, errors.messages.to_s if invalid?

        env[:request_headers][EXPIRES]   = expires
        env[:request_headers][SIGNATURE] = signature env

        @app.call env
      end

      private

      def signature(env)
        Base64.strict_encode64(
          OpenSSL::HMAC.hexdigest(
            OpenSSL::Digest::SHA256.new,
            secret_key,
            signature_seed(env)
          )
        )
      end

      def signature_seed(env)
        [
          env.method.to_s.upcase,
          api_key,
          secret_key,
          expires,
          env.url.request_uri,
          env.body.to_s
        ].join("\n")
      end
    end
  end
end
