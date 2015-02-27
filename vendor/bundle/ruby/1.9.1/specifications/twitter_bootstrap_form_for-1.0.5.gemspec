# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "twitter_bootstrap_form_for"
  s.version = "1.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stephen Touset"]
  s.date = "2011-11-28"
  s.description = "A custom Rails FormBuilder that assumes the use of Twitter Bootstrap"
  s.email = ["stephen@touset.org"]
  s.homepage = "http://github.com/stouset/twitter_bootstrap_form_for"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Rails form builder optimized for Twitter Bootstrap"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, ["~> 3"])
      s.add_runtime_dependency(%q<actionpack>, ["~> 3"])
    else
      s.add_dependency(%q<railties>, ["~> 3"])
      s.add_dependency(%q<actionpack>, ["~> 3"])
    end
  else
    s.add_dependency(%q<railties>, ["~> 3"])
    s.add_dependency(%q<actionpack>, ["~> 3"])
  end
end
