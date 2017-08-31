module Idcf
  module FaradayMiddleware
    Error            = Class.new(StandardError)
    InvalidKeys      = Class.new(Error)
    InvalidParameter = Class.new(Error)
  end
end
