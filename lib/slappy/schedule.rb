require 'securerandom'

module Slappy
  class Schedule
    include Slappy::Debuggable

    class OverScheduleError < StandardError; end
    class InvalidFormatError < StandardError; end

    DEFAULT_MAX_THREAD = 1000

    def register(schedule, options = {}, &block)
      id = options[:id] || generate_id
      schedule_list[id] = Thread.new do
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

    private

    def schedule_list
      @schedule_list ||= {}
    end

    def generate_id
      figure = Math.log10(DEFAULT_MAX_THREAD) + 1
      id = format("%0#{figure}d", SecureRandom.random_number(DEFAULT_MAX_THREAD))
      id = generate_id if schedule_list.include? id
      id
    end
  end
end
