# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'recruiter/version'

Gem::Specification.new do |spec|
  spec.name          = "recruiter"
  spec.version       = Recruiter::VERSION
  spec.authors       = ["Alvaro F. Lara"]
  spec.email         = ["alvaro.lara@alliants.com"]
  spec.summary       = %q{ An Recruiter bot for Github }
  spec.description   = %q{ An Recruiter bot for Github }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
  spec.add_dependency "redis"
  spec.add_dependency "octokit"
  spec.add_dependency "languages"
end
