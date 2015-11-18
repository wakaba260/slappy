require 'securerandom'

module Slappy
  class Schedule
    include Slappy::Debuggable

    class OverScheduleError < StandardError; end
    class InvalidFormatError < StandardError; end

    DEFAULT_MAX_THREAD = 1000

    def register(schedule, options = {}, &block)
      id = options[:id] || generate_id
      list[id] = Thread.new do
        time = Chrono::Iterator.new(schedule).next
        Debug.log "Schedule #{id} registerd to #{schedule}, first call to #{time}"
        Chrono::Trigger.new(schedule) do
          block.call
          time = Chrono::Iterator.new(schedule).next
          Debug.log "Schedule #{id} called by #{schedule}, next call to #{time}"
        end.run
      end
      id
    end

    def remove(id)
      registered = @schedule_list.include? id
      if registered
        @schedule_list[id].kill
        @schedule_list.delete id
        Debug.log "Schedule #{id} deleted"
      end
      registered
    end

    def list
      @schedule_list ||= {}
    end

    private

    def generate_id
      digit = Math.log10(DEFAULT_MAX_THREAD).to_i + 1
      id = format("%0#{digit}d", SecureRandom.random_number(DEFAULT_MAX_THREAD))
      id = generate_id if list.include? id
      id
    end
  end
end
