require 'slappy/listeners/concerns/validatable'

module Slappy
  module Listener
    class Base
      include Validatable

      def initialize(pattern, options = {}, &callback)
        self.pattern = pattern
        @options = options
        @callback = callback
      end

      def call(event)
        Debug.log "Listen event call: #{target_element}:#{event.send(target_element)}"
        return unless valid?(event)

        Debug.log "Callback event call: #{pattern}"
        @callback.call(event)
      end
    end
  end
end
