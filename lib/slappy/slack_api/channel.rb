module Slappy
  module SlackAPI
    class Channel < Base
      def name
        '#' + @data.name
      end
    end
  end
end
