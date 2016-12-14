module Slappy
  class Client
    include Slappy::Debuggable

    attr_reader :start_time

    def initialize
      Slack.configure { |slack| slack.token = config.token }
      @callbacks = {}
    end

    def client
      @client ||= Slack.realtime
    end

    def start
      setup

      Debug.log 'Slappy start'

      begin
        client.start
      rescue StandardError => e
        @callbacks[:goodnight].each(&:call) if @callbacks[:goodnight]
        STDERR.puts e.backtrace.slice!(0) + ': ' + e.message
        STDERR.puts "\tfrom " + e.backtrace.join("\n\tfrom ")
        exit 1 if config.stop_with_error
      end
    end

    def hello(&block)
      register_callback(:hello, :hello, block)
    end

    def goodnight(&block)
      register_callback(:goodnight, :goodnight, block)
    end

    def hear(pattern, options = {}, &block)
      register_callback(:hear, :message, Listener::TextListener.new(pattern, options, &block))
    end

    def respond(pattern, options = {}, &block)
      bot_name = options[:bot_name] || config.robot.botname || config.robot.username

      pattern = "^#{bot_name}[[:blank:]]#{pattern}"
      register_callback(:respond, :message, Listener::TextListener.new(pattern, options, &block))
    end

    def monitor(type, options = {}, &block)
      register_callback(:monitor, type.to_sym, Listener::TypeListener.new(type, options, &block))
    end

    def say(text, options = {})
      options[:text] = text
      Messenger.new(options).message
    end

    def schedule(pattern, options = {}, &block)
      @schedule ||= Schedule.new
      @schedule.register pattern, options, &block
      Debug.log "Add schedule event(#{@schedule.list.size}): #{pattern}"
    end

    def brain
      config.robot.brain
    end

    private

    def setup
      @start_time = Time.now

      @callbacks.each do |event_name, listeners|
        register_event event_name, listeners
      end

      set_signal_trap
    end

    def register_callback(name, type, callback)
      @callbacks[type] ||= []
      @callbacks[type].push callback
      Debug.log "Add #{name} event(#{@callbacks[type.to_sym].size}): #{type}"
    end

    def set_signal_trap
      [:TERM, :INT].each do |signal|
        Signal.trap(signal) do
          @callbacks[:goodnight].try(:each) do |callback|
            th = Thread.new { callback.call }
            th.join
          end
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
          else
            event = Event.new(data)
            listener.call(event)
          end
        end
      end
    end

    def config
      Slappy.configuration
    end
  end
end
