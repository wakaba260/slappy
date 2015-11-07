require 'slappy/client'
require 'slappy/configuration'
require 'slappy/version'

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

    def client
      @client ||= Client.new
    end

    def method_missing(method, *args, &block)
      return super unless client.respond_to?(method)
      client.send(method, *args, &block)
    end

    def respond_to?(method)
      client.respond_to?(method) || super
    end
  end
end
