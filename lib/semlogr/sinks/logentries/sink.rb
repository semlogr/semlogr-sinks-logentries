require 'semlogr/formatters/json_formatter'
require 'semlogr/sinks/logentries/tcp_connection'
require 'semlogr/sinks/batching'

module Semlogr
  module Sinks
    module Logentries
      class Sink < Semlogr::Sinks::Batching
        def initialize(token, formatter: nil, **opts)
          @token = token
          @formatter = formatter || Formatters::JsonFormatter.new
          @connection = create_connection(opts)

          super(opts)
        end

        def emit_batch(items)
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
