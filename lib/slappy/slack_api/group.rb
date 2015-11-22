module Slappy
  module SlackAPI
    class Group < Base
      self.monitor_event = %w(group_joined group_open group_rename group_unarchive group_archieve)
    end
  end
end
