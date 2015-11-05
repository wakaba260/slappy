module SlackBot
  class Event
    def initialize(data)
      @data = data
    end

    def text
      @data['text'].to_s
    end

    def method_missing(method, *args)
      key = method.to_s
      @data.key?(key) || super
      @data[key]
    end

    def respond_to_missing?(method, include_private)
      @data.key?(method.to_s) || super
    end
  end
end
