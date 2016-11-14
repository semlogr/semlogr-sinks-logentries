require 'stud/buffer'
require 'socket'
require 'openssl'
require 'semlogr/formatters/json_formatter'
require 'semlogr/sinks/logentries/tcp_connection'

module Semlogr
  module Sinks
    module Logentries
      class Sink
        include Stud::Buffer

        def initialize(token, opts = {})
          @token = token
          @options = opts
          @formatter = opts.fetch(:formatter, Formatters::JsonFormatter.new)
          @connection = create_connection(opts)

          buffer_initialize(opts)
        end

        def emit(log_event)
          buffer_receive(log_event)
        end

        def flush(items, _group = nil)
          items.each do |item|
            output = @formatter.format(item)
            @connection.write("#{@token} #{output}")
          end
        end

        private

        def create_connection(opts)
          host = opts.fetch(:host, 'data.logentries.com')
          ssl = opts.fetch(:ssl, true)
          port = opts.fetch(:port, ssl ? 443 : 80)

          TcpConnection.new(host, port, ssl)
        end
      end
    end
  end
end
