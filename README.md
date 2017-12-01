# Idcf::FaradayMiddleware
[![Code Climate](https://codeclimate.com/github/idcf/idcf-faraday_middleware/badges/gpa.svg)](https://codeclimate.com/github/idcf/idcf-faraday_middleware)
[![Issue Count](https://codeclimate.com/github/idcf/idcf-faraday_middleware/badges/issue_count.svg)](https://codeclimate.com/github/idcf/idcf-faraday_middleware)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'idcf-faraday_middleware'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install idcf-faraday_middleware

## Dependencies
  - Ruby  1.9.3 or later
  - Rails 4.2   or later

## Usage

### Computing

```ruby
require 'idcf/faraday_middleware'

Faraday::Request.register_middleware(
  signature: Idcf::FaradayMiddleware::ComputingSignature
)

@connection ||=
  Faraday.new(url: 'https://compute.jp-east.idcfcloud.com/') do |faraday|
    faraday.request :url_encoded
    faraday.request :signature, api_key: api_key, secret_key: secret_key
    faraday.response :json
    faraday.adapter Faraday.default_adapter
    faraday.options.params_encoder = Faraday::FlatParamsEncoder
  end
@connection.get '/client/api?command=listZones'
```

## ILB

```ruby
require 'idcf/faraday_middleware'

Faraday::Request.register_middleware(
  signature: Idcf::FaradayMiddleware::Signature
)

@connection ||=
  Faraday.new(url: 'https://ilb.jp-east.idcfcloud.com/') do |faraday|
    faraday.request :json
    faraday.request :signature, api_key: api_key, secret_key: secret_key
    faraday.response :json
    faraday.adapter Faraday.default_adapter
  end
@connection.get '/api/v1/loadbalancers'
```

## DNS

```ruby
require 'idcf/faraday_middleware'

Faraday::Request.register_middleware(
  signature: Idcf::FaradayMiddleware::Signature
)

@connection ||=
  Faraday.new(url: 'https://dns.idcfcloud.com/') do |faraday|
    faraday.request :json
    faraday.request :signature, api_key: api_key, secret_key: secret_key
    faraday.response :json
    faraday.adapter Faraday.default_adapter
  end
@connection.get '/api/v1/zones'
```

### Billing

```ruby
require 'idcf/faraday_middleware'

Faraday::Request.register_middleware(
  signature: Idcf::FaradayMiddleware::Signature
)

@connection ||=
  Faraday.new(url: 'https://your.idcfcloud.com/') do |faraday|
    faraday.request :json
    faraday.request :signature, api_key: api_key, secret_key: secret_key
    faraday.response :json
    faraday.adapter Faraday.default_adapter
  end
@connection.get '/api/v1/billings/history?format=json'
```

### Content Cache

```ruby
require 'idcf/faraday_middleware'

Faraday::Request.register_middleware(
  signature: Idcf::FaradayMiddleware::CdnSignature
)

@connection ||=
  Faraday.new(url: 'https://cdn.idcfcloud.com/') do |faraday|
    faraday.request :json
    faraday.request :signature, api_key: api_key, secret_key: secret_key
    faraday.response :json
    faraday.adapter Faraday.default_adapter
  end
@connection.get "/api/v0/fqdns?api_key=#{api_key}"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/idcf/idcf-faraday_middleware. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
