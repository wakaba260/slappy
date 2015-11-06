module Slappy
  class Configuration
    attr_accessor :username, :botname, :token, :icon_emoji, :channel, :icon_url

    def botname
      @botname || username
    end

    def token
      @token || ENV['SLACK_TOKEN']
    end

    def username
      @username || 'slappy'
    end

    def send_params
      { username: username, icon_emoji: icon_emoji, channel: channel, icon_url: icon_url }
    end
  end
end
