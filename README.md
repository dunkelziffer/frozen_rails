[![Gem Version](https://badge.fury.io/rb/dunkelziffer.svg)](https://rubygems.org/gems/dunkelziffer)
[![Build](https://github.com/dunkelziffer/frozen_rails/workflows/Build/badge.svg)](https://github.com/dunkelziffer/frozen_rails/actions)
[![JRuby Build](https://github.com/dunkelziffer/frozen_rails/workflows/JRuby%20Build/badge.svg)](https://github.com/dunkelziffer/frozen_rails/actions)

# Frozen Rails

TBD

## Installation

Adding to a gem:

```ruby
# my-cool-gem.gemspec
Gem::Specification.new do |spec|
  # ...
  spec.add_dependency "frozen_rails"
  # ...
end
```

Or adding to your project:

```ruby
# Gemfile
gem "frozen_rails"
```

### Supported Ruby versions

- Ruby (MRI) >= 2.7.0
- JRuby >= 9.3.0

## Usage

The gem ships with Rails generators under the `frozen` namespace. After including `frozen_rails` in your Rails application the following generators will be available:

```bash
# Setup
# - decant & kramdown
# - erb interpolation for .md files
# - rouge syntax highlighting
bin/rails g frozen:md
```

```bash
# Setup
# - SEO helpers
# - sitemap/robots skeleton
bin/rails g frozen:seo
```

```bash
# Install UI features
# - water.css
# - sample importmap pin
# - Hotwire Spark & Action Cable configuration
# - Stimulus hotkey controller
bin/rails g frozen:ui
```

```bash
# Database helpers
# - sqlite uuid patch
# - static_db initializer
# - friendly_id and Avo configuration
bin/rails g frozen:db
```

```bash
# Static site generation (Parklife) and CI
# - add parklife gem, initialize project
# - create GitHub Actions and GitLab CI workflows
# - install helper script bin/create-index-symlinks
bin/rails g frozen:ssg
```

```bash
# Developer experience helpers
# - copy custom lib templates
# - add autoload/generator config to application.rb
bin/rails g frozen:dx
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/dunkelziffer/frozen_rails](https://github.com/dunkelziffer/frozen_rails).

## Credits

This gem is generated via [`newgem` template](https://github.com/palkan/newgem) by [@palkan](https://github.com/palkan).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
