module Slappy
  module SlackAPI
    class User < Base
      self.list_name = 'members'

      def name
        '@' + @data.name
      end
    end
  end
end
