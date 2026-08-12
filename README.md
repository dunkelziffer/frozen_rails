[![Gem Version](https://badge.fury.io/rb/frozen_rails.svg)](https://rubygems.org/gems/frozen_rails)
[![Build](https://github.com/dunkelziffer/frozen_rails/workflows/Build/badge.svg)](https://github.com/dunkelziffer/frozen_rails/actions)

# Frozen Rails

This repo automates the instructions from [rails-static.com](https://rails-static.com) and a lot of additional setup which was created by me.

Running the full setup `bin/rails g frozen:rails` turns a fresh Rails application into a full static site generator that supports Markdown AND structured data (SQLite). The SSG is very developer-focused and might be cumbersome to use for non-devs.

## Installation

```bash
bundle add frozen_rails
```

## Prerequisites

- Ruby with `bundler` installed
- nvm (`node` and `yarn` must be on your `PATH`)

## Usage

The gem ships with Rails generators under the `frozen` namespace. You can run them with:
```bash
bin/rails g frozen:GENERATOR_NAME
```

The following generators are available:

| Generator | Functionality |
| --- | --- |
| `frozen:rails` | Runs `frozen:md`, `frozen:ssg`, `frozen:db` and `frozen:ui` |
| `frozen:md` | Sets up Markdown processing similar to `rails-static.com` |
| `frozen:ssg` | Sets up deploying to GitHub & GitLab pages, similar to `rails-static.com` |
| `frozen:db` | Sets up `static_db`, `avo`, `friendly_id` and fully customizes `bin/rails g scaffold` |
| `frozen:ui` | Sets up `view_component`, `lookbook`, `esbuild`, `unpoly`, `jasmine` and fully customizes `bin/rails g component` |

## More details

```bash
bin/rails g frozen:md
```
- `decant` (picks up Markdown files and provides a nice interface)
- `kramdown` (Markdown processing) with ERB interpolation
- `rouge` (syntax highlighting for Markdown code blocks)
- Routes for pages and categories.

---

```bash
bin/rails g frozen:ssg
```
- `parklife` with ActiveStorage config (crawls rack apps and emits a static site)
- GitHub pages deployment
- GitLab pages deployment

---

```bash
bin/rails g frozen:db
```
- `static_db` (SQLite <-> YAML converter)
- `sqlite_extensions-uuid` (SQLite UUID support to avoid YAML merge conflicts)
- `friendly_id` (for prettier URLs)
- `avo` (a full admin panel)
- Adjusts `bin/rails g scaffold`

---


```bash
bin/rails g frozen:ui
```
- `esbuild` and `precompiled_assets` (Rails asset pipeline alternative)
- `Unpoly` (Hotwire alternative)
- `water.css` (CSS base theme)
- `Jasmine` (JS test runner)
- `view_component`
- `lookbook`
- Adjusts `bin/rails g component`

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/dunkelziffer/frozen_rails](https://github.com/dunkelziffer/frozen_rails).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
