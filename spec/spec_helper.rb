$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'slappy'
require 'simplecov'
require 'coveralls'
require 'dotenv'

Dotenv.load

Coveralls.wear!

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '.bundle/'
end
