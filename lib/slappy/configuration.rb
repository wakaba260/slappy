module Slappy
  class Configuration
    attr_accessor :robot, :token, :scripts_dir_path, :lib_dir_path, :logger

    def initialize
      @robot = Robot.new
    end

    def logger
      unless @logger
        @logger = Logger.new(STDOUT)
        @logger.level = Logger::INFO
      end
      @logger
    end

    def token
      @token || ENV['SLACK_TOKEN']
    end

    def config_file_path
      './slappy_config.rb'
    end

    def lib_dir_path
      @lib_dir_path || './lib'
    end

    def scripts_dir_path
      @scripts_dir_path || './slappy-scripts'
    end

    def dsl
      @dsl || :enabled
    end

    def dsl=(symbol)
      fail ArgumentError if [:enabled, :disabled].include? symbol
    end

    def send_params
      {
        username: robot.username,
        icon_emoji: robot.icon_emoji,
        channel: robot.channel,
        icon_url: robot.icon_url
      }
    end
  end
end
