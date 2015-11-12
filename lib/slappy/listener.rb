module Slappy
  class Listener
    def initialize(pattern, callback)
      pattern = /#{pattern}/ if pattern.is_a? String
      @regexp = pattern
      @callback = callback
    end

    def call(event)
      return unless Time.at(event.ts.to_f) > Slappy.client.start_time
      return unless event.text.match @regexp
      @callback.call(event)
    end

    def pattern
      @regexp
    end
  end
end
