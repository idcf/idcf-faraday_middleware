require 'active_model'
require 'active_support/concern'
module Idcf
  module FaradayMiddleware
    # API KeyとSecret Keyのバリデーションを定義します
    module Validations
      extend ActiveSupport::Concern
      included do
        include ActiveModel::Validations
        validates :api_key,    presence: true, length: { is: 86 },
                               format: { with: /\A[\w\-]+\z/ }
        validates :secret_key, presence: true, length: { is: 86 },
                               format: { with: /\A[\w\-]+\z/ }
      end
    end
  end
end
