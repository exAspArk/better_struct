# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'better_struct/version'

Gem::Specification.new do |spec|
  spec.name          = "better_struct"
  spec.version       = BetterStruct::VERSION
  spec.authors       = ["Evgeny Li"]
  spec.email         = ["exaspark@gmail.com"]
  spec.summary       = %q{Use your data without pain}
  spec.description   = %q{Use your data without pain}
  spec.homepage      = "https://github.com/exAspArk/better_struct"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.5"
  spec.add_development_dependency "pry-byebug", "~> 2.0"
end
