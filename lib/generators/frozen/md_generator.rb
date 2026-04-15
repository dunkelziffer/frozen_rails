require "frozen_rails/generator"

module Frozen
  module Generators
    class MdGenerator < FrozenRails::Generator
      source_root File.expand_path("templates/md", __dir__)

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

      def copy_files
        copy_directory "controllers", "app/controllers"
        copy_directory "helpers", "app/helpers"
        copy_directory "models", "app/models"
        copy_directory "views", "app/views"
        copy_directory "initializers", "config/initializers"
        copy_directory "pages", "content/pages"
      end

      def add_config
        append_to_application_config <<~RUBY
          # frozen:md
          config.assets.paths << Rails.root.join("content")
          config.action_dispatch.rescue_responses["Decant::FileNotFound"] = :not_found
        RUBY
      end

      def add_routes
        append_to_routes <<~RUBY
          root "categories#index"

          # frozen:md
          constraints slug: Regexp.union(Category.all.map(&:slug)) do
            resources :categories, param: :slug, only: [ :index, :show ]
          end
          resources :pages, param: :slug, only: [ :show ]
        RUBY
      end

      def prepare_rouge
        copy_directory "assets/rouge", "app/assets/rouge"
        copy_file "assets/application.css", "app/assets/application.css", force: true
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
        run "rougify style #{theme} > app/assets/rouge/rouge.css"
      end
    end
  end
end
