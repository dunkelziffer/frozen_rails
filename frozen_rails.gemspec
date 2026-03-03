# frozen_string_literal: true

require_relative "lib/frozen_rails/version"

Gem::Specification.new do |s|
  s.name = "frozen_rails"
  s.version = FrozenRails::VERSION
  s.authors = ["Klaus Weidinger"]
  s.email = ["Klaus Weidinger"]
  s.homepage = "https://github.com/dunkelziffer/frozen_rails"
  s.summary = "Example description"
  s.description = "Example description"

  s.metadata = {
    "homepage_uri" => "https://github.com/dunkelziffer/frozen_rails",
    "changelog_uri" => "https://github.com/dunkelziffer/frozen_rails/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/dunkelziffer/frozen_rails/issues",
    "documentation_uri" => "https://github.com/dunkelziffer/frozen_rails/blob/main/README.md",
    "source_code_uri" => "https://github.com/dunkelziffer/frozen_rails",
    "custom_attribute" => "a, b, c"
  }

  s.license = "MIT"

  s.files = Dir.glob("lib/**/*") + Dir.glob("bin/**/*") + %w[README.md LICENSE.txt CHANGELOG.md]
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 3.2"

  s.add_dependency "rails", ">= 7.2"

  s.add_development_dependency "bundler", ">= 1.15"
  s.add_development_dependency "combustion", ">= 1.1"
  s.add_development_dependency "rake", ">= 13.0"
  s.add_development_dependency "rspec", ">= 3.9"
end
