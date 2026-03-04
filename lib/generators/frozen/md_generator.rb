# frozen_string_literal: true

require "rails/generators"

module Frozen
  module Generators
    class MdGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      # allow specifying a rouge theme programmatically; when absent the
      # generator will prompt interactively (unless running non-interactively)
      class_option :rouge_theme,
        type: :string,
        desc: "Rouge theme to install (runs non-interactive if provided)"

      desc "Set up markdown-powered content with Decant, kramdown, ERB processing and Rouge highlighting"

      # Add required gems to the application's Gemfile
      def add_gems
        gem "decant"
        gem "kramdown"
        gem "kramdown-parser-gfm"
        gem "rouge"
      end

      # Install gems
      def bundle_gems
        run "bundle"
      end

      # Generate the Page model using Decant
      def create_page_model
        template "md/page.rb", "app/models/page.rb"
      end

      # Set up helpers
      def create_helpers
        template "md/pages_helper.rb", "app/helpers/pages_helper.rb"

        # ensure application helper exists before injecting
        unless File.exist?("app/helpers/application_helper.rb")
          create_file "app/helpers/application_helper.rb", "module ApplicationHelper\nend\n"
        end

        inject_into_file "app/helpers/application_helper.rb", after: "module ApplicationHelper\n" do
          <<~RUBY
            def render_content_from(page)
              erb_processed_content = render(inline: page.content, layout: false)
              Kramdown::Document.new(
                erb_processed_content,
                input: "GFM",
                syntax_highlighter: :rouge
              ).to_html.html_safe
            end

          RUBY
        end
      end

      # Add content folder to the propshaft asset paths
      def add_assets_path
        application %(config.assets.paths << Rails.root.join("content"))
      end

      # Generate controller and view for pages
      def create_controller_and_view
        template "md/pages_controller.rb", "app/controllers/pages_controller.rb"
        template "md/show.html.erb", "app/views/pages/show.html.erb"
      end

      # Add routes for pages
      def add_routes
        route %(root "pages#show", slug: "index")
        route %(get "/*slug", to: "pages#show", as: :page)
      end

      # Create a starter content directory and index page
      def create_content_directory
        empty_directory "content/pages"
        create_file "content/pages/index.md", "# Rails Static\n"
      end

      # ask for a Rouge theme (or use provided option) and generate stylesheet
      def generate_rouge_css_hint
        theme = options[:rouge_theme]

        if theme.blank? && behavior == :invoke && $stdin.tty?
          # query the list after bundling; run in subshell so we pick up newly
          # installed gem without needing to require it in the current process.
          themes = `bundle exec ruby -e "require 'rouge'; puts Rouge::Theme.registry.keys.sort"`
            .split("\n")
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
