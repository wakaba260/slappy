module Slappy
  module SlackAPI
    class Direct < Base
      self.api_name = 'im'
      self.list_name = 'ims'
    end
  end
end
