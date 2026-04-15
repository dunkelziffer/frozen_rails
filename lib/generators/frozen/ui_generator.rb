require "frozen_rails/generator"

module Frozen
  module Generators
    class UiGenerator < FrozenRails::Generator
      source_root File.expand_path("templates/ui", __dir__)

      desc "Wire up UI helpers: classless CSS, importmap example, Hotwire Spark, Stimulus controller, and related configuration"

      def add_gems
        add_frozen_gems <<~RUBY
          # frozen:ui
          gem "view_component"
        RUBY

        add_frozen_gems <<~RUBY, env: "development"
          # frozen:ui
          gem "listen"
        RUBY

        add_frozen_gems <<~RUBY, env: "local"
          # frozen:ui
          gem "lookbook"
        RUBY
      end

      def bundle_gems
        bundle!
      end

      def prepare_js_environment
        in_root do
          run "mv .node-version .nvmrc"
          run "nvm install"
          run "npm install -g yarn"
        end
      end

      def configure_esbuild
        in_root do
          run "yarn add --dev esbuild-plugin-import-glob esbuild-plugin-text-replace"
          copy_file "esbuild.config.js"
          run 'npm pkg set type="module"'
          run 'npm pkg set scripts.build="node esbuild.config.js"'
        end
      end

      def setup_unpoly
        in_root do
          # scaffold assets folder
          # TODO: demo hotkey compiler
        end
      end

      def setup_view_component
        in_root do
          # customize generators
          # scaffold example component
        end
      end

      def setup_jasmine
        in_root do
          # install jasmine gem
          # add jasmine configuration
          # add my component extension
          # scaffold example test for hotkey_controller
        end
      end

      # def add_water_css
      #   return unless File.exist?("app/views/layouts/application.html.erb")

      #   inject_into_file "app/views/layouts/application.html.erb",
      #     after: "<head>\n" do
      #     <<~ERB
      #       <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/water.css">

      #     ERB
      #   end
      # end


      # def add_stimulus_controller
      #   template "ui/hotkey_controller.js", "app/javascript/controllers/hotkey_controller.js"
      # end
    end
  end
end
