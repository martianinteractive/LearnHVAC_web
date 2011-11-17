# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "wice_grid"
  s.version = "3.0.0.pre1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yuri Leikind"]
  s.date = "2010-12-21"
  s.description = "A Rails grid plugin to create grids with sorting, pagination, and (automatically generated) filters "
  s.email = "yuri.leikind@gmail.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "http://github.com/lekind/wice_grid"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Rails Grid Plugin"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<will_paginate>, [">= 3.0.pre2"])
    else
      s.add_dependency(%q<will_paginate>, [">= 3.0.pre2"])
    end
  else
    s.add_dependency(%q<will_paginate>, [">= 3.0.pre2"])
  end
end
