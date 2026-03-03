# frozen_string_literal: true

require "rails/generators"

module Frozen
  module Generators
    class DbGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Prepare a Rails app for SQLite UUIDs, static_db, Avo and FriendlyId"

      # add necessary gems to Gemfile
      def add_db_gems
        append_to_file "Gemfile" do
          <<~RUBY

            # support UUID primary keys with sqlite
            gem "sqlite_extensions-uuid"

            # simple read-only fixtures loader
            gem "static_db"

            # human-friendly slugs
            gem "friendly_id"

            group :development, :test do
              gem "avo", ">= 3.2"
            end
          RUBY
        end
      end

      # configure database.yml for sqlite uuid extension
      def configure_database_yml
        return unless File.exist?("config/database.yml")

        inject_into_file "config/database.yml", after: "adapter: sqlite3\n" do
          <<~YML
            extensions:
              - <%= SqliteExtensions::UUID.to_path %>
          YML
        end
      end

      # create initializer for sqlite uuid generator patch
      def create_sqlite_uuid_initializer
        template "db/sqlite_uuid.rb", "config/initializers/sqlite_uuid.rb"
      end

      # create initializer for static_db configuration
      def create_static_db_initializer
        template "db/static_db.rb", "config/initializers/static_db.rb"
      end

      # create friendly_id initializer
      def create_friendly_id_initializer
        template "db/friendly_id.rb", "config/initializers/friendly_id.rb"
      end

      # create a minimal avo initializer stub
      def create_avo_initializer
        template "db/avo.rb", "config/initializers/avo.rb"
      end

      # reminder to run migrations or generators
      def post_install_reminders
        say_status :info, "Run `bundle install` and then `rails generate friendly_id` to create slug migrations."
      end
    end
  end
end
