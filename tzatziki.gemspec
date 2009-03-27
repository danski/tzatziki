# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tzatziki}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["danski"]
  s.date = %q{2009-03-27}
  s.default_executable = %q{taz}
  s.description = %q{TODO}
  s.email = %q{dan@angryamoeba.co.uk}
  s.executables = ["taz"]
  s.extra_rdoc_files = ["README", "README.markdown", "LICENSE"]
  s.files = ["README.markdown", "VERSION.yml", "bin/taz", "lib/tzatziki", "lib/tzatziki/site.rb", "lib/tzatziki/specification.rb", "lib/tzatziki.rb", "spec/example", "spec/example/destination", "spec/example/source", "spec/example/source/_layouts", "spec/example/source/_layouts/default.html", "spec/example/source/_specifications", "spec/example/source/_types", "spec/example/source/the_google", "spec/example/source/the_google/index.textile", "spec/example/source/the_google/search.markdown", "spec/spec.opts", "spec/spec_helper.rb", "spec/tzatziki_spec.rb", "README", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/danski/tzatziki}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
