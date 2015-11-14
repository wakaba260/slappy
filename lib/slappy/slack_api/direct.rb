module Slappy
  module SlackAPI
    class Direct
      include Findable
      self.api_name = 'im'
      self.list_name = 'ims'
    end
  end
end
