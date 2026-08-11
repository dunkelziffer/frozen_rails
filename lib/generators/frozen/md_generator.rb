require "frozen_rails/generator"

module Frozen
  module Generators
    class MdGenerator < FrozenRails::Generator
      source_root File.expand_path("templates/md", __dir__)

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
        run "rougify style gruvbox.dark > app/assets/rouge/rouge.css"
      end
    end
  end
end
