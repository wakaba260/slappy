module Slappy
  class Client
    attr_reader :start_time

    def initialize
      Slack.configure { |slack| slack.token = config.token }
      @callbacks = {}
    end

    def client
      @client ||= Slack.realtime
    end

    def start
      @start_time = Time.now
      @callbacks.each do |event_name, listeners|
        register_event event_name, listeners
      end
      set_signal_trap
      client.start
    end

    def hello(&block)
      @callbacks[:hello] ||= []
      @callbacks[:hello].push block
    end

    def hear(pattern, &block)
      @callbacks[:message] ||= []
      @callbacks[:message].push Listener.new(pattern, block)
    end

    def monitor(subtype, &block)
      @callbacks[:message] ||= []
      @callbacks[:message].push SubtypeListener.new(subtype, block)
    end

    def say(text, options = {})
      options[:text] = text
      params = merge_send_params options
      Slack.chat_postMessage params
    end

    def schedule(schedule, options = {}, &block)
      @schedule ||= Schedule.new
      @schedule.register schedule, options, &block
    end

    private

    def set_signal_trap
      [:TERM, :INT].each do |signal|
        Signal.trap(signal) do
          EventMachine.stop
        end
      end
    end

    def register_event(event_name, listeners)
      client.on event_name do |data|
        listeners.each do |listener|
          case event_name
          when :hello
            listener.call
          when :message
            event = Event.new(data, listener.pattern)
            listener.call(event)
          end
        end
      end
    end

    def config
      Slappy.configuration
    end

    def merge_send_params(options)
      default = config.send_params
      default.merge options
    end
  end
end
