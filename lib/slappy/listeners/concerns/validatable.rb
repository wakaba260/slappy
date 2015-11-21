module Slappy
  module Listener
    module Validatable
      include Slappy::Debuggable

      attr_reader :pattern

      def pattern=(pattern)
        @pattern = pattern
      end

      def time_valid?(event)
        event.ts > Slappy.client.start_time
      end

      def valid?(event)
        unless time_valid?(event)
          Debug.log 'Event happend in before start time'
          return false
        end

        target = event.send(target_element)
        unless target
          Debug.log 'Target is nil'
          return false
        end

        event.matches = target.match pattern
        unless event.matches
          Debug.log "Target is not match pattern(#{pattern})"
          return false
        end

        true
      end

      def target_element
        self.class.name.split('::').last.gsub(/Listener$/, '').underscore.to_sym
      end
    end
  end
end
