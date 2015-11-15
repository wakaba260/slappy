module Slappy
  module SlackAPI
    class Group < Base
      self.monitor_event = %w(group_joined group_open)
    end
  end
end
