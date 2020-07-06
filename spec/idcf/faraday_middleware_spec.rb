require "spec_helper"

RSpec.describe Idcf::FaradayMiddleware do
  it "has a version number" do
    expect(Idcf::FaradayMiddleware::VERSION).not_to be nil
  end

  let(:random_source) { (('A'..'Z').to_a + ('a'..'z').to_a + (0..9).to_a + ['-', '_']) }
  let(:api_key) { value = ""; 86.times { value += random_source.sample(1)[0].to_s; }; value; }
  let(:secret_key) { value = ""; 86.times { value += random_source.sample(1)[0].to_s; }; value; }

  shared_examples "100000_times" do
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

  describe Idcf::FaradayMiddleware::Signature do
    let(:app) { DummyAppSignature.new api_key, secret_key }
    subject { described_class.new app, api_key: api_key, secret_key: secret_key }
    describe "#call" do
      it_behaves_like "100000_times"
    end
  end

  describe Idcf::FaradayMiddleware::CdnSignature do
    let(:app) { DummyAppCdnSignature.new api_key, secret_key }
    subject { described_class.new app, api_key: api_key, secret_key: secret_key }
    describe "#call" do
      it_behaves_like "100000_times"
    end
  end
end
