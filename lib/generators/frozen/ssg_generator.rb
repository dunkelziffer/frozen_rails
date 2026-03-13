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
        copy_file "ssg/gitlab/.gitlab-ci.yml", ".gitlab-ci.yml"
        copy_file "ssg/bin/create-index-symlinks", "bin/create-index-symlinks"
        chmod "bin/create-index-symlinks", 0o755
      end

    end
  end
end
