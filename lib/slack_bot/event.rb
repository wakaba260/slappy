require 'hashie'
require 'forwardable'

module SlackBot
  class Event
    extend Forwardable

    attr_reader :match_data

    def_delegators :@data, :method_missing, :respond_to_missing?

    def initialize(data, pattern)
      @data = Hashie::Mash.new data
      @match_data = text.match pattern
    end

    def text
      @data['text'].to_s
    end
  end
end
