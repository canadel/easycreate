# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "steak"
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luismi Cavall\u{c3}\u{a9}"]
  s.date = "2011-06-14"
  s.description = "Steak is a minimal extension of RSpec-Rails that adds several conveniences to do acceptance testing of Rails applications using Capybara. It's an alternative to Cucumber in plain Ruby."
  s.email = "luismi@lmcavalle.com"
  s.homepage = "http://github.com/cavalle/steak"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "The delicious combination of RSpec and Capybara for Acceptance BDD"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec-rails>, [">= 2.5.0"])
      s.add_runtime_dependency(%q<capybara>, [">= 1.0.0"])
    else
      s.add_dependency(%q<rspec-rails>, [">= 2.5.0"])
      s.add_dependency(%q<capybara>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<rspec-rails>, [">= 2.5.0"])
    s.add_dependency(%q<capybara>, [">= 1.0.0"])
  end
end
