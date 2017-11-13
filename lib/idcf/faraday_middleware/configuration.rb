module Idcf
  module FaradayMiddleware
    # 各種定数を定義します
    module Configuration
      HEADER_API_KEY   = 'X-IDCF-APIKEY'.freeze
      HEADER_EXPIRES   = 'X-IDCF-Expires'.freeze
      HEADER_SIGNATURE = 'X-IDCF-Signature'.freeze
      EXPIRES          = 'Expired'.freeze
      SIGNATURE        = 'Signature'.freeze
      SIGNATURE_TTL    = 600
      PARTIALLY_DECODE = [
        %w(+ %20),
        %w(%2A *),
        %w(%5B [),
        %w(%5D ])
      ].freeze
    end
  end
end
