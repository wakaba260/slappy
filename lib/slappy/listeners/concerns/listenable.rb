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

        target = event.send(target_element)
        return unless target

        event.matches = target.match pattern
        return unless event.matches

        @callback.call(event)
      end

      def time_valid?(event)
        event.ts > Slappy.client.start_time
      end

      private

      def target_element
        self.class.name.split('::').last.gsub(/Listener$/, '').underscore.to_sym
      end
    end
  end
end
