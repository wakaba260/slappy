module Slappy
  module SlackAPI
    class Pin < Base
      self.list_name = 'items'
      self.monitor_event = %w(pin_added pin_removed)
    end
  end
end
