module SlackBot
  class Listener
    def initialize(regexp, callback)
      @regexp = regexp
      @callback = callback
    end

    def call(event)
      return unless event.text.match @regexp
      @callback.call(event)
    end

    def pattern
      @regexp
    end
  end
end
