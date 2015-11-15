module Slappy
  class Event
    extend Forwardable

    attr_accessor :matches

    def_delegators :@data, :method_missing, :respond_to_missing?

    def initialize(data)
      @data = Hashie::Mash.new data
    end

    def text
      @data['text'].to_s
    end
  end
end
