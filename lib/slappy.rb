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
  end
end
