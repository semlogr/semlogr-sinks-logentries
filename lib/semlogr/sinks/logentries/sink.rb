require 'logstash-logger'
require 'semlogr/sinks/logentries/version'
require 'semlogr/formatters/json_formatter'

module Semlogr
  module Sinks
    module Logentries
      class Sink
        def initialize(token)
          @token = token
          @formatter = Formatters::JsonFormatter.new
          @device = LogStashLogger::Device.new(type: :tcp, host: 'data.logentries.com', port: 443, use_ssl: true)
        end

        def emit(log_event)
          output = @formatter.format(log_event)
          @device.write("#{@token} #{output}")
        end
      end
    end
  end
end
