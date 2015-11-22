module Slappy
  module SlackAPI
    class File < Base
      self.monitor_event =
        %w(file_created file_deleted file_change file_public file_shared file_unshared)
    end
  end
end
