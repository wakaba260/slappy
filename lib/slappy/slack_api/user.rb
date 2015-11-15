module Slappy
  module SlackAPI
    class User < Base
      self.list_name = 'members'
      self.monitor_event = 'team_join'

      def name
        '@' + @data.name
      end
    end
  end
end
