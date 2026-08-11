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
          gem "precompiled_assets"
        RUBY

        comment_lines "Gemfile", /propshaft/
        comment_lines "Gemfile", /jsbundling-rails/
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
          run "nvm use"
          run "nvm install"
          run "npm install -g yarn"
        end
      end

      def configure_esbuild
        in_root do
          run "yarn add --dev esbuild-plugin-import-glob esbuild-plugin-text-replace esbuild-manifest-plugin"
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
        remove_dir "app/javascript"
        copy_directory "assets", "app/assets"
        copy_file "application.html.erb", "app/views/layouts/application.html.erb", force: true
      end

      def switch_to_precompiled_assets
        in_root do
          # CAUTION: Very brittle!
          FileUtils.move("content/pages/rails-static", "app/assets/images/pages/rails-static")
        end
        comment_lines "config/application.rb", /config\.assets\.paths/
        comment_lines "config/environments/development.rb", /config\.assets\.quiet/
        remove_file "config/initializers/assets.rb"

        insert_into_file ".github/workflows/ci.yml", <<YAML1, before: "\n      - name: Run tests", force: true

      - uses: actions/setup-node@v6
        with:
          node-version-file: '.nvmrc'
          cache: 'yarn'
      - run: npm install -g yarn
      - run: yarn install --frozen-lockfile
YAML1

        insert_into_file ".github/workflows/ci.yml", <<YAML2, before: "\n      - name: Run System Tests", force: true

      - uses: actions/setup-node@v6
        with:
          node-version-file: '.nvmrc'
          cache: 'yarn'
      - run: npm install -g yarn
      - run: yarn install --frozen-lockfile
YAML2

        insert_into_file ".github/workflows/parklife.yml", <<YAML3, after: "bundler-cache: true\n"

    - uses: actions/setup-node@v6
      with:
        node-version-file: '.nvmrc'
        cache: 'yarn'
    - run: npm install -g yarn
    - run: yarn install --frozen-lockfile

YAML3

        insert_into_file ".gitlab-ci.yml", <<YAML4, after: "    - bundle install\n"
    - npm install -g yarn
    - yarn install --frozen-lockfile
YAML4
      end

      def setup_view_component
        copy_file "application_component.rb", "app/components/application_component.rb"
        copy_directory "lib", "lib"

        append_to_application_config <<~RUBY
          # frozen:ui
          config.i18n.available_locales = [ :en, :de ]
          config.view_component.parent_class = "ApplicationComponent"
          config.view_component.generate.preview = true
          config.view_component.generate.preview_path = "test/components"
          config.view_component.generate.locale = true
          config.view_component.previews.default_layout = "component_preview"
          config.asset_path = "/assets"
        RUBY
      end

      def setup_lookbook
        copy_file "lookbook/lookbook_helper.rb", "app/helpers/lookbook_helper.rb"
        copy_file "lookbook/component_preview.html.erb", "app/views/layouts/component_preview.html.erb"

        config = <<~RUBY
          # frozen:ui
          config.lookbook.preview_paths = [ "test/components" ]
          config.lookbook.preview_collection_label = "Components"
          config.lookbook.page_collection_label = "Documentation"
          config.lookbook.page_route = "docs"
          config.lookbook.page_paths = [ "test/components/docs" ]
          config.lookbook.ui_theme = "zinc"
        RUBY

        append_to_application_config config, env: "development"
        append_to_application_config config, env: "test"
      end

      def setup_jasmine
        copy_directory "jasmine/views", "app/views"
        copy_file "jasmine/controllers/jasmine_controller.rb", "app/controllers/jasmine_controller.rb"
      end

      def add_routes
        append_to_routes <<~RUBY
          # frozen:ui
          if Rails.env.local?
            mount Lookbook::Engine, at: "/lookbook"
            resources :jasmine, only: [ :index ]
          end
        RUBY
      end

      def copy_demo_component
        copy_directory "demo_component", "app/components"
        copy_directory "demo_component_tests", "test/components"
      end
    end
  end
end
