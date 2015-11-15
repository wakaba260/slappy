require 'active_support'
require 'active_support/core_ext'
require 'active_support/concern'
require 'chrono'
require 'forwardable'
require 'hashie'
require 'slack'
require 'termcolor'
require 'thor'
require 'logger'

module Slappy
  class << self
    extend Forwardable

    def_delegators :configuration, :logger
    def_delegators :client, :start, :hello, :hear, :say, :schedule, :monitor

    def configure
      @configuration = Configuration.new

      yield configuration if block_given?

      configuration
    end

    def configuration
      @configuration || configure
    end

    def client
      @client ||= Client.new
    end
  end
end

require 'slappy/slack_api/concerns/findable'
require 'slappy/slack_api/base'
require 'slappy/slack_api/channel'
require 'slappy/slack_api/direct'
require 'slappy/slack_api/group'
require 'slappy/slack_api/user'
require 'slappy/cli'
require 'slappy/client'
require 'slappy/configuration'
require 'slappy/configuration/robot'
require 'slappy/commands/generator.rb'
require 'slappy/commands/run.rb'
require 'slappy/event'
require 'slappy/listener'
require 'slappy/schedule'
require 'slappy/subtype_listener'
require 'slappy/version'
