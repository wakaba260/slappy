require 'forwardable'
require 'active_support/core_ext/string/inflections'
require 'hashie'
require 'slack'
require 'termcolor'
require 'thor'
require 'logger'

module Slappy
  class << self
    @configuration = nil

    def configure
      @configuration = Configuration.new

      yield configuration if block_given?

      configuration
    end

    def configuration
      @configuration || configure
    end

    def logger
      configuration.logger
    end

    def method_missing(method, *args, &block)
      return super unless client.respond_to?(method)
      client.send(method, *args, &block)
    end

    def respond_to?(method)
      client.respond_to?(method) || super
    end

    private

    def client
      @client ||= Client.new
    end
  end
end

require 'slappy/cli'
require 'slappy/client'
require 'slappy/configuration'
require 'slappy/configuration/robot'
require 'slappy/commands/generator.rb'
require 'slappy/commands/run.rb'
require 'slappy/event'
require 'slappy/listener'
require 'slappy/version'
