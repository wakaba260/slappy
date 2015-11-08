module Slappy
  class Event
    extend Forwardable

    attr_reader :matches

    def_delegators :@data, :method_missing, :respond_to_missing?

    def initialize(data, pattern)
      @data = Hashie::Mash.new data
      @matches = text.match pattern
    end

    def text
      @data['text'].to_s
    end
  end
end
