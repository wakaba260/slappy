module Slappy
  module SlackAPI
    class User < Base
      self.list_name = 'members'
      self.monitor_event = %w(team_join user_change)

      def name
        '@' + @data.name
      end
    end
  end
end
