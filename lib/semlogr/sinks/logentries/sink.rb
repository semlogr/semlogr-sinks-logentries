require 'stud/buffer'
require 'socket'
require 'openssl'
require 'semlogr/sinks/logentries/version'
require 'semlogr/formatters/json_formatter'

module Semlogr
  module Sinks
    module Logentries
      class Sink
        include Stud::Buffer

        def initialize(token, **opts)
          @token = token
          @options = opts
          @formatter = opts.fetch(:formatter, Formatters::JsonFormatter.new)

          buffer_initialize(opts)
        end

        def emit(log_event)
          buffer_receive(log_event)
        end

        def flush(items, _group = nil)
          with_connection do |conn|
            items.each do |item|
              output = @formatter.format(item)
              conn.write("#{@token} #{output}")
            end
          end
        end

        private

        def connected?
          !@connection.nil?
        end

        def with_connection
          open_connection unless connected?

          begin
            yield(@connection)
          rescue
            close_connection
          end
        end

        def open_connection
          host = @options.fetch(:host, 'data.logentries.com')
          use_ssl = @options.fetch(:use_ssl, true)
          port = @options.fetch(:port, use_ssl ? 443 : 80)
          connection = TCPSocket.new(host, port)

          if use_ssl
            cert_store = OpenSSL::X509::Store.new
            cert_store.set_default_paths

            ssl_context = OpenSSL::SSL::SSLContext.new
            ssl_context.cert_store = cert_store
            ssl_context.verify_mode = OpenSSL::SSL::VERIFY_PEER

            connection = OpenSSL::SSL::SSLSocket.new(connection, ssl_context)
            connection.sync_close = true
            connection.connect
          end

          @connection = connection
        end

        def close_connection
          if @connection.respond_to?(:sysclose)
            @connection.sysclose
          elsif @connection.respond_to?(:close)
            @connection.close
          end
        ensure
          @connection = nil
        end
      end
    end
  end
end
