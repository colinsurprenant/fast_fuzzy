# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fast_fuzzy/version'

Gem::Specification.new do |spec|
  spec.name          = "fast_fuzzy"
  spec.version       = FastFuzzy::VERSION
  spec.authors       = ["Colin Surprenant"]
  spec.email         = ["colin.surprenant@gmail.com"]

  spec.summary       = "JRuby Fast and fuzzy text pattern matching using Lucene analyzers"
  spec.description   = "JRuby Fast and fuzzy text pattern matching using Lucene analyzers"
  spec.homepage      = "https://github.com/colinsurprenant/fast_fuzzy"
  spec.licenses      = ["Apache-2.0"]

  spec.files         = Dir.glob(["*.gemspec", "lib/**/*.jar", "lib/**/*.rb", "spec/**/*.rb", "LICENSE", "README.md"])
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.platform      = "java"

  spec.add_runtime_dependency "jar-dependencies"

  spec.requirements << "jar org.apache.lucene:lucene-core, 5.4.1"
  spec.requirements << "jar org.apache.lucene:lucene-analyzers-common, 5.4.1"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
