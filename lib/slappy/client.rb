require 'slack'
require 'slappy/event'
require 'slappy/listener'
require 'slappy/configuration'

module Slappy
  class Client
    def initialize
      Slack.configure { |slack| slack.token = config.token }
      @listeners = {}
    end

    def client
      @client ||= Slack.realtime
    end

    def start
      @listeners.each do |key, array|
        client.on key do |data|
          array.each do |listener|
            event = Event.new(data, listener.pattern) if key == :message
            listener.call(event)
          end
        end
      end
      client.start
    end

    def hello(&block)
      @listeners[:hello] ||= []
      @listeners[:hello].push block
    end

    def hear(regexp, &block)
      @listeners[:message] ||= []
      @listeners[:message].push Listener.new(regexp, block)
    end

    private

    def config
      Slappy.configuration
    end
  end
end
