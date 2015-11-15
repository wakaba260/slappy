module Slappy
  module SlackAPI
    class Direct < Base
      self.api_name = 'im'
      self.list_name = 'ims'
      self.monitor_event = 'im_open'
    end
  end
end
