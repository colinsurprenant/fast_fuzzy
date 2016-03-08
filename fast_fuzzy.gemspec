# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fast_fuzzy/version'

Gem::Specification.new do |spec|
  spec.name          = "fast_fuzzy"
  spec.version       = FastFuzzy::VERSION
  spec.authors       = ["Colin Surprenant"]
  spec.email         = ["colin.surprenant@gmail.com"]

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = Dir.glob(["*.gemspec", "lib/**/*.jar", "lib/**/*.rb", "spec/**/*.rb"])
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.platform = "java"

  spec.add_runtime_dependency "jar-dependencies"

  spec.requirements << "jar org.apache.lucene:lucene-core, 5.4.1"
  spec.requirements << "jar org.apache.lucene:lucene-analyzers-common, 5.4.1"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
