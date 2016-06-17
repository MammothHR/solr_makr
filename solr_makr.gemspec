# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'solr_makr/version'

Gem::Specification.new do |spec|
  spec.name          = "solr_makr"
  spec.version       = SolrMakr::VERSION
  spec.authors       = ["Alexa Grey"]
  spec.email         = ["alexag@hranswerlink.com"]
  spec.summary       = %q{Create and manage solr collections programmatically}
  spec.description   = %q{Create and manage solr collections programmatically}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport",      ">= 3.2.0", "< 5"
  spec.add_dependency "active_interaction", "~> 3.1.0"
  spec.add_dependency "attr_lazy",          "~> 0.0.2"
  spec.add_dependency "commander",          "~> 4.3.0"
  spec.add_dependency "httparty",           "~> 0.13.7"
  spec.add_dependency "lmdb",               "~> 0.4.8"
  spec.add_dependency "rugged",             "~> 0.24.0"
  spec.add_dependency "terminal-table",     "~> 1.5.2"
  spec.add_dependency "toml-rb",            "~> 0.3.14"
  spec.add_dependency "virtus",             "~> 1.0"
  spec.add_dependency "zk"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sunspot_solr", "2.2.5" # compatibility with solr 5.3.1
  spec.add_development_dependency "pry"
end
