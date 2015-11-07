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

    def hear(pattern, &block)
      @listeners[:message] ||= []
      @listeners[:message].push Listener.new(pattern, block)
    end

    def say(text, options = {})
      options[:text] = text
      params = merge_send_params options
      Slack.chat_postMessage params
    end

    private

    def config
      Slappy.configuration
    end

    def merge_send_params(options)
      default = config.send_params
      default.merge options
    end
  end
end
