module Slappy
  class Configuration
    class Robot
      attr_accessor :botname, :username, :channel, :icon_emoji, :icon_url

      def botname
        @botname || username
      end

      def username
        @username || 'slappy'
      end
    end
  end
end
