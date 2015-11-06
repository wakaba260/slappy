$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'slappy'
require 'dotenv'
require 'simplecov'
require 'codeclimate-test-reporter'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  CodeClimate::TestReporter::Formatter
]
SimpleCov.start

Dotenv.load
