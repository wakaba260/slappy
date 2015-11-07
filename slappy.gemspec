# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slappy/version'

Gem::Specification.new do |spec|
  spec.name          = "slappy"
  spec.version       = Slappy::VERSION
  spec.authors       = ["wakaba260"]
  spec.email         = ["wakaba260@aiming-inc.com"]

  spec.summary       = %q{Simple Slack Bot Framework}
  spec.description   = %q{Simple Slack Bot Framework. Use Slack RealTime API and Web API.}
  spec.homepage      = "https://github.com/wakaba260/slappy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'slack-api'
  spec.add_dependency 'hashie'
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "guard-rubocop"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "activesupport"
end
