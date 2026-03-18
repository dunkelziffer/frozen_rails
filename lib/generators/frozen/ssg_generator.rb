# frozen_string_literal: true

require "frozen_rails/generator"

module Frozen
  module Generators
    class SsgGenerator < FrozenRails::Generator
      source_root File.expand_path("templates/ssg", __dir__)

      desc "Set up Parklife static site generation with CI workflows and helper scripts"

      def add_gems
        add_frozen_gems <<~RUBY
          # frozen:ssg
          gem "parklife-rails"
        RUBY
      end

      def bundle_gems
        bundle!
      end

      def run_parklife_init
        run "bundle exec parklife init --rails --github-pages"
        append_to_file ".gitignore", "# frozen:ssg\n/build\n"
      end

      def setup_gitlab_pages
        copy_file ".gitlab-ci.yml"
        comment_lines "Parkfile", /config\.nested_index = false/
      end

      def configure_parklife_active_storage_integration
        copy_file "storage.yml", "config/storage.yml", force: true

        uncomment_lines "config/environments/production.rb", /config\.assume_ssl = true/
        gsub_file "config/environments/production.rb", /config\.active_storage\.service = :\w+/, "config.active_storage.service = :parklife"

        insert_into_file "config/application.rb", "\n" + <<~RUBY, before: /(\n#.*)?\n#.*\nBundler\.require/
          # frozen:ssg
          if ARGV.first == "build"
            require "parklife-rails/activestorage"
          end
        RUBY
      end
    end
  end
end
