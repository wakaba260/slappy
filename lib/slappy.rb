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

    def slappy
      @client ||= Client.new
    end

    def method_missing(method, *args, &block)
      return super unless slappy.respond_to?(method)
      slappy.send(method, *args, &block)
    end

    def respond_to?(method)
      slappy.respond_to?(method) || super
    end
  end
end
