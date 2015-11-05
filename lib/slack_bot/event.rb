require 'hashie'
require 'forwardable'

module SlackBot
  class Event
    extend Forwardable

    def_delegators :@data, :method_missing, :respond_to_missing?

    def initialize(data)
      @data = Hashie::Mash.new data
    end

    def text
      @data['text'].to_s
    end
  end
end
