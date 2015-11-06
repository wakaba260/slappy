# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slappy/version'

Gem::Specification.new do |spec|
  spec.name          = "slappy"
  spec.version       = Slappy::VERSION
  spec.authors       = ["yuemori"]
  spec.email         = ["yuemori@aiming-inc.com"]

  spec.summary       = %q{Slack bot maker}
  spec.description   = %q{Simple Slack bot maker. This gem wapper to Slack Realtime API}
  spec.homepage      = "https://github.com/yuemori/slappy"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

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
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "codeclimate-test-reporter"
end
