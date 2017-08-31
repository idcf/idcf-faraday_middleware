require 'base64'
require 'faraday'
require 'active_support'
require 'active_support/core_ext/class/attribute'
require 'active_support/dependencies/autoload'

require 'idcf/faraday_middleware/version'
require 'idcf/faraday_middleware/errors'

module Idcf
  # 各クラスを読み込みます
  module FaradayMiddleware
    extend ActiveSupport::Autoload
    autoload :Signature,          'idcf/faraday_middleware/signature'
    autoload :CdnSignature,       'idcf/faraday_middleware/cdn_signature'
    autoload :ComputingSignature, 'idcf/faraday_middleware/computing_signature'
    autoload :Configuration,      'idcf/faraday_middleware/configuration'
    autoload :Validations,        'idcf/faraday_middleware/validations'
  end
end
