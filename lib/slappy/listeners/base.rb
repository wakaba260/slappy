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
        channel = "channel: #{event.try(:channel).try(:name)}"
        element = "#{target_element}: #{event.try(target_element)}"
        Debug.log "Listen event call(#{channel} / #{element})"

        return unless valid?(event)
        return unless target?(event)

        Debug.log "Callback event call: #{pattern}"
        @callback.call(event)
      end

      private

      def target_element
        self.class.name.split('::').last.gsub(/Listener$/, '').underscore.to_sym
      end
    end
  end
end
