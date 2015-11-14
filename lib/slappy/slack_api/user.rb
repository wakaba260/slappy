module Slappy
  module SlackAPI
    class User
      include Findable

      self.list_name = 'members'

      def name
        '@' + @data.name
      end
    end
  end
end
