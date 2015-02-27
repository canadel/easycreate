# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "log_buddy"
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rob Sanheim"]
  s.date = "2010-12-06"
  s.description = "Log statements along with their name easily.  Mixin a logger everywhere when you need it."
  s.email = "rsanheim@gmail.com"
  s.extra_rdoc_files = ["LICENSE", "README.markdown"]
  s.files = ["LICENSE", "README.markdown"]
  s.homepage = "http://github.com/relevance/log_buddy"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Log Buddy is your little development buddy."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.2"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.2"])
      s.add_dependency(%q<mocha>, ["~> 0.9"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.2"])
    s.add_dependency(%q<mocha>, ["~> 0.9"])
  end
end
