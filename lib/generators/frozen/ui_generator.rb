# frozen_string_literal: true

require "rails/generators"

module Frozen
  module Generators
    class UiGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Wire up UI helpers: classless CSS, importmap example, Hotwire Spark, Stimulus controller, and related configuration"

      def add_water_css
        return unless File.exist?("app/views/layouts/application.html.erb")

        inject_into_file "app/views/layouts/application.html.erb",
          after: "<head>\n" do
          <<~ERB
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/water.css">

          ERB
        end
      end

      def ensure_importmap_rb
        if File.exist?("config/importmap.rb")
          append_to_file "config/importmap.rb" do
            <<~RUBY

              # example pin added by frozen:ui
              pin "canvas-confetti", to: "https://cdn.jsdelivr.net/npm/canvas-confetti@1/dist/confetti.module.mjs"
            RUBY
          end
        else
          create_file "config/importmap.rb", <<~RUBY
            # Pin additional scripts to the importmap here.
            # pin "canvas-confetti", to: "https://cdn.jsdelivr.net/npm/canvas-confetti@1/dist/confetti.module.mjs"
          RUBY
        end
      end

      def add_stimulus_controller
        template "ui/hotkey_controller.js", "app/javascript/controllers/hotkey_controller.js"
      end

      def add_spark_gem
        gem_group :development do
          gem "hotwire-spark"
        end
      end

      # Install gems
      def bundle_gems
        Bundler.with_unbundled_env do
          system("bundle install")
        end
      end

      def configure_spark
        return unless File.exist?("config/environments/development.rb")

        inject_into_file "config/environments/development.rb",
          after: "Rails.application.configure do\n" do
          <<~RUBY
            config.hotwire.spark.html_paths += %w[ content ]
            config.hotwire.spark.html_extensions += %w[ md ]

          RUBY
        end
      end

      def enable_action_cable
        if File.exist?("config/application.rb")
          inject_into_file "config/application.rb",
            before: "module" do
            "require \"action_cable/engine\"\n"
          end
        end

        template "ui/cable.yml", "config/cable.yml" unless File.exist?("config/cable.yml")
      end
    end
  end
end
