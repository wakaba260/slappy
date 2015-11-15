module Slappy
  module Listener
    module Listenable
      include ActiveSupport::Concern

      attr_reader :pattern

      def initialize(target, callback)
        @pattern = target
        @callback = callback
      end

      def call(event)
        return unless time_valid?(event)
        target_element = self.class.name.split('::').last.gsub(/Listener$/, '').underscore.to_sym
        event.matches = event.send(target_element).match pattern
        return unless event.matches
        @callback.call(event)
      end

      def time_valid?(event)
        Time.at(event.ts.to_f) > Slappy.client.start_time
      end
    end
  end
end
