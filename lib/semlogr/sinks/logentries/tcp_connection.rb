require 'stud/buffer'
require 'socket'
require 'openssl'
require 'semlogr/sinks/logentries/version'

module Semlogr
  module Sinks
    module Logentries
      class TcpConnection
        def initialize(host, port, ssl)
          @host = host
          @port = port
          @ssl = ssl
        end

        def connected?
          !@socket.nil?
        end

        def write(data)
          connect unless connected?

          @socket.write(data)
        rescue StandardError
          close

          raise
        end

        def connect
          socket = TCPSocket.new(@host, @port)

          configure_socket_keepalive(socket)

          if @ssl
            cert_store = OpenSSL::X509::Store.new
            cert_store.set_default_paths

            ssl_context = OpenSSL::SSL::SSLContext.new
            ssl_context.cert_store = cert_store
            ssl_context.verify_mode = OpenSSL::SSL::VERIFY_PEER

            socket = OpenSSL::SSL::SSLSocket.new(socket, ssl_context)
            socket.hostname = @host if socket.respond_to? :hostname=
            socket.sync_close = true
            socket.connect
          end

          @socket = socket
        end

        def close
          if @socket.respond_to?(:sysclose)
            @socket.sysclose
          elsif @socket.respond_to?(:close)
            @socket.close
          end
        ensure
          @socket = nil
        end

        private

        def configure_socket_keepalive(connection)
          return unless %i[
            SOL_SOCKET
            SO_KEEPALIVE
            SOL_TCP
            TCP_KEEPIDLE
            TCP_KEEPINTVL
            TCP_KEEPCNT
          ].all? { |c| Socket.const_defined?(c) }

          connection.setsockopt(Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, true)
          connection.setsockopt(Socket::SOL_TCP, Socket::TCP_KEEPIDLE, 60)
          connection.setsockopt(Socket::SOL_TCP, Socket::TCP_KEEPINTVL, 5)
          connection.setsockopt(Socket::SOL_TCP, Socket::TCP_KEEPCNT, 5)
        end
      end
    end
  end
end
