module Slappy
  class Configuration
    attr_accessor :robot, :token, :scripts_dir_path

    def initialize
      @robot = Robot.new
    end

    def token
      @token || ENV['SLACK_TOKEN']
    end

    def config_file_path
      './slappy_config.rb'
    end

    def scripts_dir_path
      @scripts_dir_path || './slappy-scripts'
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
