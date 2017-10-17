require 'semlogr/sinks/logentries/version'
require 'semlogr/sinks/logentries/sink'
require 'semlogr/component_registry'

module Semlogr
  module Sinks
    module Logentries
      def self.new(token, opts = {})
        Sink.new(token, opts)
      end
    end

    ComponentRegistry.register(:sink, logentires: Logentries)
  end
end
