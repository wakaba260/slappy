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
      @start_time = Time.now
      @callbacks.each do |event_name, listeners|
        register_event event_name, listeners
      end
      set_signal_trap
      Debug.log 'Slappy start'
      begin
        client.start
      rescue StandardError => e
        @callbacks[:goodnight].each(&:call)
        raise e, e.message
      end
    end

    def hello(&block)
      @callbacks[:hello] ||= []
      @callbacks[:hello].push block
      Debug.log "Add hello event(#{@callbacks[:hello].size})"
    end

    def goodnight(&block)
      @callbacks[:goodnight] ||= []
      @callbacks[:goodnight].push block
      Debug.log "Add goodnight event(#{@callbacks[:goodnight].size})"
    end

    def hear(pattern, &block)
      @callbacks[:message] ||= []
      @callbacks[:message].push Listener::TextListener.new(pattern, block)
      Debug.log "Add here event(#{@callbacks[:message].size}): #{pattern}"
    end

    def monitor(type, &block)
      @callbacks[type.to_sym] ||= []
      @callbacks[type.to_sym].push Listener::TypeListener.new(type, block)
      Debug.log "Add monitor event(#{@callbacks[type.to_sym].size}): #{type}"
    end

    def say(text, options = {})
      options[:text] = text
      Messanger.new(options).message
    end

    def schedule(pattern, options = {}, &block)
      @schedule ||= Schedule.new
      @schedule.register pattern, options, &block
      Debug.log "Add schedule event(#{@schedule.list.size}): #{pattern}"
    end

    private

    def set_signal_trap
      [:TERM, :INT].each do |signal|
        Signal.trap(signal) do
          @callbacks[:goodnight].each do |callback|
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
