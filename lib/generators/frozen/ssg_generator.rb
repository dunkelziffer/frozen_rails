# frozen_string_literal: true

require "rails/generators"

module Frozen
  module Generators
    class SsgGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Set up Parklife static site generation with CI workflows and helper scripts"

      def add_parklife_gem
        append_to_file "Gemfile" do
          <<~RUBY

            # Static site generation with Parklife
            gem "parklife-rails"
          RUBY
        end
      end

      def run_parklife_init
        say_status :info, "running parklife init (requires bundle install)"
        # attempt to run initialization if parklife is available
        if system("bundle exec parklife init --rails --github-pages")
          say_status :info, "parklife initialized"
        else
          say_status :warn, "unable to run parklife init; please execute manually"
        end
      end

      def copy_github_actions
        template "ssg/ci.yml", ".github/workflows/ci.yml"
      end

      def copy_gitlab_ci
        template "ssg/gitlab-ci.yml", ".gitlab-ci.yml"
      end

      def create_symlink_script
        template "ssg/create-index-symlinks", "bin/create-index-symlinks"
        chmod "bin/create-index-symlinks", 0o755
      end

      def post_install_message
        say_status :info, <<~MSG
          Parklife gem added. After bundle install you may need to run:
            bundle exec parklife init --rails --github-pages
          to finish configuration.
          The CI workflows and helper script have been placed in your project.
        MSG
      end
    end
  end
end
