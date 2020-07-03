require "spec_helper"

RSpec.describe Idcf::FaradayMiddleware do
  it "has a version number" do
    expect(Idcf::FaradayMiddleware::VERSION).not_to be nil
  end

  describe Idcf::FaradayMiddleware::Signature do
    class DummyApp
      def initialize(secret_key)
        @secret_key = secret_key
      end

      def call env
        env
      end

      def check env
        @api_key = env[:request_headers][Idcf::FaradayMiddleware::Configuration::HEADER_API_KEY]
        @expires = env[:request_headers][Idcf::FaradayMiddleware::Configuration::HEADER_EXPIRES]
        env[:request_headers][Idcf::FaradayMiddleware::Configuration::HEADER_SIGNATURE] == signature(create_env)
      end

      class DummyEnv < OpenStruct
        def method
          "method"
        end
      end

      def create_env
        env = DummyEnv.new(url: OpenStruct.new(path: "path", query: "query"), request_headers: {})
      end

      private

      def signature env
        Base64.strict_encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest::SHA256.new,
            @secret_key,
            signature_seed(env)
          )
        )
      end

      def signature_seed env
        [
          env.method.to_s.upcase,
          env.url.path,
          @api_key,
          @expires,
          env.url.query.to_s.gsub('+', '%20')
        ].join("\n")
      end
    end

    let(:random_source) { (('A'..'Z').to_a + ('a'..'z').to_a + (0..9).to_a + ['-', '_']) }
    let(:api_key) { value = ""; 86.times { value += random_source.sample(1)[0].to_s; }; value; }
    let(:secret_key) { value = ""; 86.times { value += random_source.sample(1)[0].to_s; }; value; }
    let(:app) { DummyApp.new secret_key }

    subject { described_class.new app, api_key: api_key, secret_key: secret_key }

    describe "#call" do
      context "10000 times" do
        specify do
          try = 100000
          cnt = 0
          try.times do |idx|
            env = subject.call(app.create_env)
            break unless app.check(env)
            cnt = idx + 1
          end
          expect(cnt).to eq(try)
        end
      end
    end
  end
end
