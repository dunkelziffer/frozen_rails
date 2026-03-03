# frozen_string_literal: true

require "rails/generators"

module Frozen
  module Generators
    class MdGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Set up markdown-powered content with Decant, kramdown, ERB processing and Rouge highlighting"

      # Add required gems to the application's Gemfile
      def add_gems
        gem "decant"
        gem "kramdown"
        gem "kramdown-parser-gfm"
        gem "rouge"
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

      # remind user to generate rouge stylesheet if rouge is present
      def generate_rouge_css_hint
        say_status :info, "To add Rouge styles, run:\n    rougify style github > app/assets/stylesheets/rouge.css", :blue
      end
    end
  end
end
