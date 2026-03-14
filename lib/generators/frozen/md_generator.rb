# frozen_string_literal: true

require "frozen_rails/generator"

module Frozen
  module Generators
    class MdGenerator < FrozenRails::Generator
      source_root File.expand_path("templates", __dir__)

      # When absent, the generator will prompt interactively (unless running non-interactively).
      class_option :rouge_theme, type: :string, desc: "Rouge theme to install (runs non-interactive if provided)"

      desc "Set up markdown-powered content with Decant, kramdown, ERB processing and Rouge highlighting"

      def add_gems
        add_frozen_gems <<~RUBY
          # frozen:md
          gem "decant"
          gem "kramdown"
          gem "kramdown-parser-gfm"
          gem "rouge"
        RUBY
      end

      def bundle_gems
        bundle!
      end

      def create_content_directory
        empty_directory "content/pages"
      end

      def copy_files
        app_files = [
          "controllers/categories_controller.rb",
          "controllers/pages_controller.rb",
          "helpers/markdown_helper.rb",
          "models/concerns/linkable.rb",
          "models/category.rb",
          "models/page.rb",
          "views/categories/index.html.erb",
          "views/categories/show.html.erb",
          "views/pages/show.html.erb"
        ]

        app_files.each do |app_file|
          copy_file "md/#{app_file}", "app/#{app_file}"
        end

        config_files = [
          "initializers/decant_extensions.rb"
        ]

        config_files.each do |config_file|
          copy_file "md/#{config_file}", "config/#{config_file}"
        end

        content_files = [
          "pages/frozen-rails.md",
          "pages/rails-static.md",
          "pages/rails-static/rails-static-logo.webp"
        ]

        content_files.each do |content_file|
          copy_file "md/#{content_file}", "content/#{content_file}"
        end
      end

      def add_config
        append_to_application_config <<~RUBY
          # frozen:md
          config.assets.paths << Rails.root.join("content")
          config.action_dispatch.rescue_responses["Decant::FileNotFound"] = :not_found
        RUBY
      end

      # Add routes for pages
      def add_routes
        append_to_routes <<~RUBY
          # frozen:md
          root "categories#index"

          # Use `Regexp.union` instead of array for constraints!
          # https://github.com/rails/rails/issues/47726
          constraints slug: Regexp.union(Category.all.map(&:slug)) do
            resources :categories, param: :slug, only: [:index, :show]
          end

          resources :pages, param: :slug, only: [:show]
        RUBY
      end

      def generate_rouge_css_stylesheet
        theme = options[:rouge_theme]

        if theme.blank? && behavior == :invoke && $stdin.tty?
          # Run in subshell so we pick up newly installed gem without needing to require it in the current process.
          themes = `bundle exec ruby -e "require 'rouge'; puts Rouge::Theme.registry.keys.sort"`.split("\n")

          say_status :info, "Available Rouge themes (#{themes.size}):", :blue
          themes.each_with_index { |t, i| say "  #{i + 1}. #{t}" }

          answer = ask("Choose a theme (name or number) [github]")

          theme = if /^\d+$/.match?(answer)
            themes[answer.to_i - 1]
          else
            answer.presence
          end
        end

        theme ||= "github"

        say_status :info, "Generating Rouge CSS for theme #{theme}", :blue
        run "rougify style #{theme} > app/assets/stylesheets/rouge.css"
      end
    end
  end
end
