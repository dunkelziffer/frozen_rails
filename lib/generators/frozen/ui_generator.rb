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

      def add_js_dependencies
        in_root do
          run "yarn add unpoly"
          run "yarn add --dev jasmine jasmine_dom_matchers"
        end
      end

      def replace_assets
        # Remove everything from app/assets except app/assets/rouge
        in_root do
          assets_path = Pathname.new("app/assets")
          FileUtils.mkdir_p(assets_path) unless assets_path.exist?

          assets_path.children.each do |entry|
            next if entry.basename.to_s == "rouge"

            FileUtils.rm_rf(entry)
          end
        end

        copy_directory "assets", "app/assets"
      end

      def setup_unpoly
        in_root do
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
          # add my component extension
          # scaffold example test for hotkey_controller
        end
      end

      # def add_stimulus_controller
      #   template "ui/hotkey_controller.js", "app/javascript/controllers/hotkey_controller.js"
      # end
    end
  end
end
