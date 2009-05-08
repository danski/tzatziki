# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tzatziki}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["danski"]
  s.date = %q{2009-05-08}
  s.default_executable = %q{taz}
  s.description = %q{TODO}
  s.email = %q{dan@angryamoeba.co.uk}
  s.executables = ["taz"]
  s.extra_rdoc_files = ["README.markdown", "LICENSE"]
  s.files = ["README.markdown", "VERSION.yml", "bin/taz", "lib/tzatziki", "lib/tzatziki/api.rb", "lib/tzatziki/core_ext", "lib/tzatziki/core_ext/hash.rb", "lib/tzatziki/core_ext/http_request.rb", "lib/tzatziki/core_ext/http_response.rb", "lib/tzatziki/core_ext/string.rb", "lib/tzatziki/document.rb", "lib/tzatziki/documentable.rb", "lib/tzatziki/errors.rb", "lib/tzatziki/example.rb", "lib/tzatziki/filters.rb", "lib/tzatziki/layout.rb", "lib/tzatziki/parsable.rb", "lib/tzatziki/site.rb", "lib/tzatziki/specification.rb", "lib/tzatziki/tags", "lib/tzatziki/tags/highlight.rb", "lib/tzatziki/tags/include.rb", "lib/tzatziki/testable.rb", "lib/tzatziki/text_formatter.rb", "lib/tzatziki/type.rb", "lib/tzatziki.rb", "spec/api_spec.rb", "spec/document_spec.rb", "spec/documentable_spec.rb", "spec/example", "spec/example/destination", "spec/example/source", "spec/example/source/_layouts", "spec/example/source/_layouts/default.html", "spec/example/source/_layouts/document.html", "spec/example/source/_layouts/specification.html", "spec/example/source/_layouts/type.html", "spec/example/source/_specifications", "spec/example/source/_specifications/successful.markdown", "spec/example/source/_types", "spec/example/source/_types/date.html", "spec/example/source/config.yml", "spec/example/source/github", "spec/example/source/github/config.yml", "spec/example/source/github/show_repo.markdown", "spec/example/source/github/show_user.textile", "spec/example/source/images", "spec/example/source/images/345ytdsfsd.jpeg", "spec/example/source/index.html", "spec/example/source/the_google", "spec/example/source/the_google/_layouts", "spec/example/source/the_google/_layouts/custom.html", "spec/example/source/the_google/_specifications", "spec/example/source/the_google/_specifications/searchable.markdown", "spec/example/source/the_google/_types", "spec/example/source/the_google/_types/search_query.markdown", "spec/example/source/the_google/config.yml", "spec/example/source/the_google/ignore_me~/index.markdown", "spec/example/source/the_google/index.textile", "spec/example/source/the_google/mail", "spec/example/source/the_google/mail/index.html", "spec/example/source/the_google/search.examples", "spec/example/source/the_google/search.examples/different_phrase.markdown", "spec/example/source/the_google/search.markdown", "spec/example_spec.rb", "spec/http_request_spec.rb", "spec/http_response_spec.rb", "spec/layout_spec.rb", "spec/parsable_spec.rb", "spec/site_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/specification_spec.rb", "spec/testable_spec.rb", "spec/type_spec.rb", "spec/tzatziki_spec.rb", "LICENSE"]
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
