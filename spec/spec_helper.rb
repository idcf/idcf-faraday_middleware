require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter '/vendor/'
end

require 'bundler/setup'
require 'faraday'
require 'faraday_middleware'
require 'idcf/faraday_middleware'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class DummyAppSignature
  def initialize(api_key, secret_key)
    @api_key    = api_key
    @secret_key = secret_key
  end

  def call env
    env
  end

  def check env
    @expires = env[:request_headers][header_expires]
    env[:request_headers][header_signature] == signature(create_env)
  end

  class DummyEnv < OpenStruct
    def method
      "method"
    end
  end

  def create_env
    env = DummyEnv.new(url: OpenStruct.new(path: "path", query: "query", request_uri: "request_uri"), request_headers: {}, body: "body")
  end

  private

  def header_expires
    Idcf::FaradayMiddleware::Configuration::HEADER_EXPIRES
  end

  def header_signature
    Idcf::FaradayMiddleware::Configuration::HEADER_SIGNATURE
  end

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

class DummyAppCdnSignature < DummyAppSignature
  private

  def header_expires
    Idcf::FaradayMiddleware::Configuration::EXPIRES
  end

  def header_signature
    Idcf::FaradayMiddleware::Configuration::SIGNATURE
  end

  def signature(env)
    Base64.strict_encode64(
      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest::SHA256.new,
        @secret_key,
        signature_seed(env)
      )
    )
  end

  def signature_seed env
    [
      env.method.to_s.upcase,
      @api_key,
      @secret_key,
      @expires,
      env.url.request_uri,
      env.body.to_s
    ].join("\n")
  end
end
