module Slappy
  module Listener
    module Listenable
      include ActiveSupport::Concern
      include Slappy::Debuggable

      attr_reader :pattern

      def initialize(target, callback)
        @pattern = target
        @callback = callback
      end

      def call(event)
        Debug.log "Listen event call: #{target_element}:#{event.send(target_element)}"

        unless time_valid?(event)
          Debug.log 'Event happend in before start time'
          return
        end

        target = event.send(target_element)
        unless target
          Debug.log 'Target is nil'
          return
        end

        event.matches = target.match pattern
        unless event.matches
          Debug.log "Target is not match pattern(#{pattern})"
          return
        end

        Debug.log "Callback event call: #{pattern}"
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
