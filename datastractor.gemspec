# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'datastractor/version'

Gem::Specification.new do |spec|
  spec.name          = "datastractor"
  spec.version       = Datastractor::VERSION
  spec.authors       = ["Kyle Campos"]
  spec.email         = ["kyle.campos@gmail.com"]

  spec.summary       = %q{Manage API interactions between configurable data sources and analytic data systems}
  spec.description   = %q{Provides a flexible interface to extract data from configurable data sources and 
    push them into a configurable set of analytic systems, typically for dashboarding purposes.}
  spec.homepage      = "https://github.com/aaa-ncnu-ie/datastractor"
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

  spec.add_dependency "httparty", "~> 0.14"
  spec.add_dependency "databox", "~> 0.2.2"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
