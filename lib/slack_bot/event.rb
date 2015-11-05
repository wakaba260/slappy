module SlackBot
  class Event
    def initialize(data)
      @data = data
    end

    def text
      @data[:text].to_s
    end

    def method_missing(method, *args)
      @data.key?(method) || super
      @data[method]
    end

    def respond_to_missing?(method, include_private)
      @data.key?(method) || super
    end
  end
end
