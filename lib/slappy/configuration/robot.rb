module Slappy
  class Configuration
    class Robot
      attr_accessor :botname, :username, :channel, :icon_emoji, :icon_url, :as_user, :brain

      def as_user
        @as_user || false
      end

      def botname
        @botname || username
      end

      def username
        @username || 'slappy'
      end

      def brain
        @brain ||= Slappy::Brain::Memory.new
      end
    end
  end
end
