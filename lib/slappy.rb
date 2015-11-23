require 'active_support'
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
    def_delegators :client, :start, :hello, :hear, :say, :schedule, :monitor, :goodnight, :respond

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

require 'slappy/concerns/debuggable'
require 'slappy/slack_api'
require 'slappy/brain'
require 'slappy/cli'
require 'slappy/client'
require 'slappy/configuration'
require 'slappy/configuration/robot'
require 'slappy/commands/generator.rb'
require 'slappy/commands/run.rb'
require 'slappy/event'
require 'slappy/listener'
require 'slappy/messenger'
require 'slappy/schedule'
require 'slappy/version'
