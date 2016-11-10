require 'logstash-logger'
require 'semlogr/sinks/logentries/version'
require 'semlogr/formatters/json_formatter'

module Semlogr
  module Sinks
    module Logentries
      class Sink
        def initialize(token, **opts)
          @token = token
          @formatter = opts.fetch(:formatter, Formatters::JsonFormatter.new)
          @device = create_device(opts)
        end

        def emit(log_event)
          output = @formatter.format(log_event)
          @device.write("#{@token} #{output}")
        end

        private

        def create_device(opts)
          opts = opts.merge(
            type: opts.fetch(:type, :tcp),
            host: 'data.logentries.com',
            use_ssl: opts.fetch(:use_ssl, true)
          )

          case opts[:type]
          when :tcp
            opts[:port] = opts[:use_ssl] ? 443 : 80
          when :udp
            opts[:port] = 80
            opts[:use_ssl] = false
          else
            raise ArgumentError, 'The logentries sink only supports tcp and udp.'
          end

          LogStashLogger::Device.new(opts)
        end
      end
    end
  end
end
