# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ensurable/version"

Gem::Specification.new do |s|
  s.name        = "ensurable"
  s.version     = Ensurable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jesse Storimer"]
  s.email       = ["jstorimer@gmail.com"]
  s.homepage    = "http://github.com/jstorimer/ensurable"
  s.summary     = %q{Kind of like Bundler, but for system deps, and a lot less features}
  s.description = %q{Ensurable gives you a DSL for defining the system development dependencies of your app. It's kind of like Bundler, but for system deps, and does a lot less.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'yard'
end
