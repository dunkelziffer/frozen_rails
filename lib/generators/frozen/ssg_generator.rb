# frozen_string_literal: true

require "frozen_rails/generator"

module Frozen
  module Generators
    class SsgGenerator < FrozenRails::Generator
      source_root File.expand_path("templates", __dir__)

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
        unless system("bundle exec parklife init --rails --github-pages")
          say_status :warn, "Unable to run parklife init. Please execute manually!"
        end
      end

      def setup_gitlab_pages
        copy_file "ssg/.gitlab-ci.yml", ".gitlab-ci.yml"
        comment_lines "Parkfile", /config\.nested_index = false/
      end

      # TODO:
      # - Add `/build` to `.gitignore`
      # - storage.yml
      # - `config/environments/production.rb`:
      #   - `config.active_storage.service = :parklife`
      #   - `config.assume_ssl = true``
      # - `config/application.rb`
      #   - Parklive ActiveStorage integration
    end
  end
end
