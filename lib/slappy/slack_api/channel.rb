module Slappy
  module SlackAPI
    class Channel < Base
      self.monitor_event = 'channel_created'

      def name
        '#' + @data.name
      end
    end
  end
end
