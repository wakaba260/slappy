require 'simplecov'
require 'codeclimate-test-reporter'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  CodeClimate::TestReporter::Formatter
]
SimpleCov.start do
  add_filter '/spec/'
end

RSpec.configure do |config|
  config.before(:all) { Slappy.configure { |c| c.logger = Logger.new(nil) } }
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'slappy'
