[![Gem Version](https://badge.fury.io/rb/dunkelziffer.svg)](https://rubygems.org/gems/dunkelziffer)
[![Build](https://github.com/dunkelziffer/frozen_rails/workflows/Build/badge.svg)](https://github.com/dunkelziffer/frozen_rails/actions)
[![JRuby Build](https://github.com/dunkelziffer/frozen_rails/workflows/JRuby%20Build/badge.svg)](https://github.com/dunkelziffer/frozen_rails/actions)

# Frozen Rails

DISCLAIMER: I generated this repo with AI and haven't tested it yet.
I will verify manually verify the functionality and use AI to generate a test suite as soon as I get to it. Until then, use at your own risk.

This repo automates the instructions from [rails-static.com](https://rails-static.com) and some additional setup which was created by me.

Running the full setup `bin/rails g frozen:rails` should turn a fresh Rails application into a full static-site generator that supports Markdown AND structured data (SQLite). The SSG is very developer-focused and might be cumbersome to use for non-devs.

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
# ✅ passes, ❓ works correctly, ❌ has test suite
# Setup
# - decant & kramdown
# - erb interpolation for .md files
# - rouge syntax highlighting (chooses a theme interactively)
#   pass `--rouge_theme=name` to run non-interactive
bin/rails g frozen:md
```

```bash
# ✅ passes, ❓ works correctly, ❌ has test suite
# Database helpers
# - sqlite uuid patch
# - static_db initializer
# - friendly_id and Avo configuration
bin/rails g frozen:db
```

```bash
# ✅ passes, ❓ works correctly, ❌ has test suite
# Setup
# - SEO helpers
# - sitemap/robots skeleton
bin/rails g frozen:seo
```

```bash
# ❓ passes, ❓ works correctly, ❌ has test suite
# Install UI features
# - water.css
# - sample importmap pin
# - Hotwire Spark & Action Cable configuration
# - Stimulus hotkey controller
bin/rails g frozen:ui
```

```bash
# ❓ passes, ❓ works correctly, ❌ has test suite
# Developer experience helpers
# - copy custom lib templates
# - add autoload/generator config to application.rb
bin/rails g frozen:dx
```

```bash
# ❓ passes, ❓ works correctly, ❌ has test suite
# Static site generation (Parklife) and CI
# - add parklife gem, initialize project
# - create GitHub Actions and GitLab CI workflows
# - install helper script bin/create-index-symlinks
bin/rails g frozen:ssg
```

```bash
# ❓ passes, ❓ works correctly, ❌ has test suite
# Full Rails setup (runs all frozen generators in order)
bin/rails g frozen:rails
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/dunkelziffer/frozen_rails](https://github.com/dunkelziffer/frozen_rails).

## Credits

This gem is generated via [`newgem` template](https://github.com/palkan/newgem) by [@palkan](https://github.com/palkan).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
