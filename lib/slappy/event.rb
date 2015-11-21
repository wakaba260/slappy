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

    def channel
      SlackAPI::Channel.find(id: @data['channel']) ||
        SlackAPI::Group.find(id: @data['channel']) ||
        SlackAPI::Direct.find(id: @data['channel'])
    end

    def user
      SlackAPI::User.find(id: @data['user'])
    end

    def ts
      Time.at(@data['ts'].to_f)
    end

    def bot?
      if @data['subtype'] && @data['subtype'] == 'bot_message'
        return true
      else
        return false
      end
    end
  end
end
