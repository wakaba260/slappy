require 'securerandom'

module Slappy
  class Schedule
    class OverScheduleError < StandardError; end
    class InvalidFormatError < StandardError; end

    DEFAULT_MAX_THREAD = 1000

    def register(schedule, options = {}, &block)
      id = options[:id] || generate_id
      schedule_list[id] = Thread.new { Chrono::Trigger.new(schedule) { block.call }.run }
      Slappy.logger.try(:debug, "Schedule registerd to #{schedule}")
      id
    end

    def remove(id)
      registered = @schedule_list.include? id
      if registered
        @schedule_list[id].kill
        @schedule_list.delete id
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
