# frozen_string_literal: true

require "rails/generators"

module Frozen
  module Generators
    class DxGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Install developer experience helpers: custom lib templates and generator config"

      # copy over the lib folder content from static example
      def copy_lib_templates
        directory "dx/lib", "lib"
      end

      # inject configuration into config/application.rb
      def configure_application
        return unless File.exist?("config/application.rb")

        inject_into_file "config/application.rb",
          after: "class Application < Rails::Application\n" do
          <<~RUBY
            # Please, add to the `ignore` list any other `lib` subdirectories that do
            # not contain `.rb` files, or that should not be reloaded or eager loaded.
            # Common ones are `templates`, `generators`, or `middleware`, for example.
            config.autoload_lib(ignore: %w[assets tasks])

            config.generators do |g|
              g.orm :active_record, primary_key_type: :uuid
              g.test_framework false
            end

            config.active_storage.draw_routes = true

          RUBY
        end
      end
    end
  end
end
