module Slappy
  module SlackAPI
    class Channel
      include Findable

      def name
        '#' + @data.name
      end
    end
  end
end
