require_relative "lib/frozen_rails/version"

Gem::Specification.new do |s|
  s.name = "frozen_rails"
  s.version = FrozenRails::VERSION
  s.license = "MIT"
  s.authors = [ "Klaus Weidinger" ]
  s.email = [ "weidkl@gmx.de" ]

  s.summary = "Generators for turning Rails into an SSG"
  s.description = s.summary
  s.homepage = "https://github.com/dunkelziffer/frozen_rails"

  s.metadata = {
    "source_code_uri" => s.homepage,
    "homepage_uri" => s.homepage,
    "changelog_uri" => "#{s.homepage}/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "#{s.homepage}/issues",
    "documentation_uri" => "#{s.homepage}/blob/main/README.md",
    "rubygems_mfa_required" => "true"
  }

  # CONTENTS

  gemspec = File.basename(__FILE__)
  s.files = `git ls-files`
    .split("\n")
    .reject { |f| File.symlink?(f) }
    .reject { |f| f == gemspec }
    .reject { |f| f.start_with?(*%w[.github/ bin/ docs/ spec/ .gem_release.yml .gitignore .rspec .rubocop.yml .ruby-version Gemfile Gemfile.lock]) }
  s.require_paths = [ "lib" ]

  s.bindir = "exe"
  s.executables = []

  # DEPENDENCIES

  s.required_ruby_version = ">= 3.2"

  s.add_dependency "rails", ">= 8.1"
end
