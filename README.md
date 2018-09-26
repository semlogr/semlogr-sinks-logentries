![Codeship Status for semlogr/semlogr-sinks-logentries](https://codeship.com/projects/9677cdd0-8768-0134-57f3-36c2ccf79a16/status?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/6209103d407f5483a216/maintainability)](https://codeclimate.com/github/semlogr/semlogr-sinks-logentries/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/6209103d407f5483a216/test_coverage)](https://codeclimate.com/github/semlogr/semlogr-sinks-logentries/test_coverage)

# Logenties sink for Semlogr

This sink provides support for writing logs to [logentries](https://logentries.com/), the sink currently makes use of the device within the logstash-logger gem which provides a buffered device
for writing entries to logentries in batches and saved me a bunch of time to get this sink off the ground.

## Installation

To install:

    gem install semlogr-sinks-logentries

Or if using bundler, add semlogr to your Gemfile:

    gem 'semlogr-sinks-logentries'

then:

    bundle install

## Getting Started

Create an instance of the logger configuring the logentries sink with your token.

```ruby
require 'semlogr'
require 'semlogr/sinks/logentries'

Semlogr.logger = Semlogr.create_logger do |c|
  c.log_at :info

  c.write_to :logentries, 'TOKEN'
end

Semlogr.info('Customer {customer_id} did something interesting', customer_id: 1234)
```

## Development

After cloning the repository run `bundle install` to get up and running, to run the specs just run `rake spec`.

## Contributing

See anything broken or something you would like to improve? feel free to submit an issue or better yet a pull request!
