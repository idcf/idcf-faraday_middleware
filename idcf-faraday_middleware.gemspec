# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'idcf/faraday_middleware/version'

Gem::Specification.new do |spec|
  spec.name          = 'idcf-faraday_middleware'
  spec.version       = Idcf::FaradayMiddleware::VERSION
  spec.authors       = ['IDC Frontier Inc.']

  spec.summary       = 'A Ruby client for IDCF Cloud Service.'
  # spec.description   = ''
  spec.homepage      = 'https://www.idcf.jp/english/cloud/'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', '>= 4.2'
  spec.add_runtime_dependency 'activemodel', '>= 4.2'
  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'faraday_middleware'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'awesome_print'

  spec.required_ruby_version = '>= 1.9.3'
end
