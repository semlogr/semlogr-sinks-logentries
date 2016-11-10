require 'semlogr/sinks/logentries/sink'

module Semlogr
  module Sinks
    module Logentries
      def self.new(token, **opts)
        Sink.new(token, **opts)
      end
    end
  end
end
