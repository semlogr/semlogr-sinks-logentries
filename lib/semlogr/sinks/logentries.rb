require 'semlogr/sinks/logentries/sink'

module Semlogr
  module Sinks
    module Logentries
      def self.new(token)
        Sink.new(token)
      end
    end
  end
end
