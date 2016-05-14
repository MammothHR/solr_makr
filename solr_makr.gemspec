# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'solr_makr/version'

Gem::Specification.new do |spec|
  spec.name          = "solr_makr"
  spec.version       = SolrMakr::VERSION
  spec.authors       = ["Alexa Grey"]
  spec.email         = ["alexag@hranswerlink.com"]
  spec.summary       = %q{Create a solr core programmatically}
  spec.description   = %q{Create a solr core programmatically}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 3.2.0", "< 5"
  spec.add_dependency "attr_lazy"
  spec.add_dependency "commander", "~> 4.3.0"
  spec.add_dependency "nokogiri"
  spec.add_dependency "typhoeus"
  spec.add_dependency "virtus", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
