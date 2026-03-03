# frozen_string_literal: true

require "rails/generators"

module Frozen
  module Generators
    class SeoGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Add SEO helpers, metadata partials and sitemap/robots models"

      # add meta partial and update layout
      def create_og_partial
        template "seo/_og_meta_tags.html.erb", "app/views/layouts/_og_meta_tags.html.erb"
      end

      def inject_layout_tags
        return unless File.exist?("app/views/layouts/application.html.erb")

        inject_into_file "app/views/layouts/application.html.erb",
          after: "<head>\n" do
          <<~ERB
            <%= render 'layouts/og_meta_tags', tags: {
              title: title,
              description: description,
              image: image_url('og-image.jpg'),
              author: author,
              type: "website",
              site_name: site_name,
              url: canonical_url,
            } %>

            <%= tag :link, rel: "canonical", href: canonical_url %>

            <%= favicon_link_tag 'favicon.ico', sizes: '32x32' %>
            <%= favicon_link_tag 'icon.svg', type: 'image/svg+xml' %>
            <%= favicon_link_tag 'apple-touch-icon.png', rel: 'apple-touch-icon' %>

            <%= tag :meta, name: "robots", content: robots_content %>

          ERB
        end
      end

      # helpers for meta tags
      def add_application_helpers
        unless File.exist?("app/helpers/application_helper.rb")
          create_file "app/helpers/application_helper.rb", "module ApplicationHelper\nend\n"
        end

        inject_into_file "app/helpers/application_helper.rb",
          after: "module ApplicationHelper\n" do
          <<~RUBY
            def site_name
              "Rails Static"
            end

            def title
              [ @page&.title.presence, site_name ].uniq.compact.join(" · ")
            end

            def description
              @page.frontmatter&.dig(:description)
            end

            def author
              "François Catuhe"
            end

            def canonical_url
              url_for(only_path: false)
            end

            def robots_content
              Rails.env.production? ? "index, follow" : "noindex, nofollow"
            end

            def og_meta_tag(key, content)
              case key
              when :title, :description, :image
                tag(:meta, name: key, property: "og:\#{key}", content: content)
              when :author
                tag(:meta, name: key, content: content)
              else
                tag(:meta, property: "og:\#{key}", content: content)
              end
            end

          RUBY
        end
      end

      def add_favicon_notice
        say_status :info, "Add favicons (favicon.ico, icon.svg, apple-touch-icon.png) to app/assets/images and create og-image.jpg"
      end

      # sitemap models
      def create_sitemap_models
        template "seo/sitemap.rb", "app/models/sitemap.rb"
        template "seo/sitemap_entry.rb", "app/models/sitemap/entry.rb"
        template "seo/robots_generatable.rb", "app/models/sitemap/robots_generatable.rb"
      end

      def remove_default_robots
        remove_file "public/robots.txt" if File.exist?("public/robots.txt")
      end
    end
  end
end
