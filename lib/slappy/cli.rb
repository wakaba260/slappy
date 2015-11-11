module Slappy
  class CLI < Thor
    desc 'start', 'slappy start'
    def start
      build_command(:run).call
    end

    desc 'new [DIR_NAME]', 'create new slappy project'
    def new(dir_name = nil)
      build_command(:generator).call(dir_name)
    end

    desc 'version', 'show version number'
    def version
      puts Slappy::VERSION
    end

    private

    def build_command(command_name)
      "Slappy::Commands::#{command_name.to_s.camelize}".constantize.new
    end
  end
end
