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
