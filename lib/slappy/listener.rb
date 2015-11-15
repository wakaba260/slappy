module Slappy
  class Listener
    attr_reader :pattern

    def initialize(pattern, callback)
      pattern = /#{pattern}/ if pattern.is_a? String
      @pattern = pattern
      @callback = callback
    end

    def call(event)
      return unless Time.at(event.ts.to_f) > Slappy.client.start_time
      event.matches = event.text.match pattern
      return unless event.matches
      @callback.call(event)
    end
  end
end
