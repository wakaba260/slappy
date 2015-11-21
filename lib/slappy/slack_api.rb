require 'slappy/slack_api/concerns/findable'
require 'slappy/slack_api/base'
require 'slappy/slack_api/channel'
require 'slappy/slack_api/direct'
require 'slappy/slack_api/file'
require 'slappy/slack_api/group'
require 'slappy/slack_api/user'
require 'slappy/slack_api/pin'

module Slappy
  module SlackAPI
    class SlackError < StandardError
      def exception(error_message = nil)
        error_message = "#{error_message}. Error detail is see: https://api.slack.com/methods"
        super(error_message)
      end
    end

    def self.find(value)
      [:Channel, :Group, :Direct, :User].each do |klass|
        klass = "Slappy::SlackAPI::#{klass}".constantize
        result = (klass.find(id: value) || klass.find(name: value))
        return result if result
      end
      nil
    end
  end
end
