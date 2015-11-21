require 'slappy/listeners/concerns/targettable'
require 'slappy/listeners/concerns/validatable'

module Slappy
  module Listener
    class Base
      include Validatable
      include Targettable

      def initialize(pattern, options = {}, &callback)
        self.pattern = pattern
        if options[:from]
          target.channel = options[:from][:channel]
          target.user = options[:from][:user]
        end
        @callback = callback
      end

      def call(event)
        Debug.log "Listen event call: #{target_element}:#{event.send(target_element)}"

        return unless valid?(event)
        return unless target?(event)

        Debug.log "Callback event call: #{pattern}"
        @callback.call(event)
      end
    end
  end
end
