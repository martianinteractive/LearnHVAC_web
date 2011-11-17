# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "jammit"
  s.version = "0.6.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Ashkenas"]
  s.date = "2011-05-26"
  s.description = "    Jammit is an industrial strength asset packaging library for Rails,\n    providing both the CSS and JavaScript concatenation and compression that\n    you'd expect, as well as YUI Compressor and Closure Compiler compatibility,\n    ahead-of-time gzipping, built-in JavaScript template support, and optional\n    Data-URI / MHTML image embedding.\n"
  s.email = "jeremy@documentcloud.org"
  s.executables = ["jammit"]
  s.extra_rdoc_files = ["README"]
  s.files = ["bin/jammit", "README"]
  s.homepage = "http://documentcloud.github.com/jammit/"
  s.rdoc_options = ["--title", "Jammit", "--exclude", "test", "--main", "README", "--all"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "jammit"
  s.rubygems_version = "1.8.10"
  s.summary = "Industrial Strength Asset Packaging for Rails"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<yui-compressor>, [">= 0.9.3"])
    else
      s.add_dependency(%q<yui-compressor>, [">= 0.9.3"])
    end
  else
    s.add_dependency(%q<yui-compressor>, [">= 0.9.3"])
  end
end
