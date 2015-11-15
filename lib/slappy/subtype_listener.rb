module Slappy
  class SubtypeListener
    def initialize(subtype, callback)
      @subtype = subtype
      @callback = callback
    end

    def call(event)
      return unless time_valid?(event)
      return unless event.subtype.match @subtype
      @callback.call(event)
    end

    def time_valid?(event)
      Time.at(event.ts.to_f) > Slappy.client.start_time
    end
  end
end
