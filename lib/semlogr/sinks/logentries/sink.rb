require 'stud/buffer'
require 'socket'
require 'timeout'
require 'openssl'
require 'semlogr/formatters/json_formatter'
require 'semlogr/sinks/logentries/tcp_connection'

module Semlogr
  module Sinks
    module Logentries
      class Sink
        include Stud::Buffer

        def initialize(token, formatter: nil, **opts)
          opts = default_opts.merge(opts)

          @token = token
          @formatter = formatter || Formatters::JsonFormatter.new
          @connection = create_connection(opts)

          exit_handler_initialize(opts)
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

        def default_opts
          {
            flush_at_exit: true,
            flush_at_exit_timeout: 60
          }
        end

        def exit_handler_initialize(opts)
          return unless opts[:flush_at_exit]

          at_exit do
            flush_timeout = opts[:flush_at_exit_timeout]
            Timeout.timeout(flush_timeout) do
              buffer_flush(final: true)

              @connection.close
            end
          end
        end

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
