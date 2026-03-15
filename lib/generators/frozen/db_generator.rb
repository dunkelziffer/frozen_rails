# frozen_string_literal: true

require "frozen_rails/generator"

module Frozen
  module Generators
    class DbGenerator < FrozenRails::Generator
      source_root File.expand_path("templates", __dir__)

      desc "Prepare a Rails app for SQLite UUIDs, static_db, Avo and FriendlyId"

      def add_gems
        add_frozen_gems <<~RUBY
          # frozen:db
          gem "sqlite_extensions-uuid"
          gem "static_db"
          gem "friendly_id"
        RUBY

        add_frozen_gems <<~RUBY, env: "development"
          # frozen:db
          gem "avo", ">= 3.2"
        RUBY
      end

      def bundle_gems
        bundle!
      end

      def add_routes
        append_to_routes <<~RUBY
          # frozen:db
          if Rails.env.development?
            mount_avo at: "/avo"
          end
        RUBY
      end

      def copy_files
        copy_file "db/database.yml", "config/database.yml", force: true
        copy_directory "db/initializers", "config/initializers"
        copy_directory "db/lib", "lib"
      end

      def configure_application
        # TODO: Maybe Avo hotfix
        # TODO: add `templates` and `generators` to `config.autoload_lib(ignore: %w[assets tasks])`

        append_to_application_config <<~RUBY
          # frozen:db
          config.generators do |g|
            g.orm :active_record, primary_key_type: :uuid
            g.test_framework false
          end
          config.active_storage.draw_routes = true
        RUBY
      end

      def prepare_db
        rails_command "db:create"
        rails_command "db:schema:load"
      end

      def setup_active_storage
        rails_command "active_storage:install"

        active_storage_migration = in_root { Dir.glob("db/migrate/*.active_storage.rb").first }

        gsub_file active_storage_migration, /# Use.*\n.*primary_and_foreign_key_types/, <<~RUBY.chomp.lines.map(&:chomp).join("\n    ")
          # Use custom primary and foreign key types to support SQLite UUIDs.
          primary_key_type = { id: :string, default: -> { "uuid()" }, limit: 36 }
          foreign_key_type = { type: :string, limit: 36 }
        RUBY
        gsub_file active_storage_migration, "id: primary_key_type", "**primary_key_type"
        gsub_file active_storage_migration, "type: foreign_key_type", "**foreign_key_type"
        gsub_file active_storage_migration, /\n\s*private.*end(?=\nend)/m, ""
      end

      def setup_friendly_id
        rails_command "g migration create_friendly_id_slugs"

        friendly_id_migration = in_root { Dir.glob("db/migrate/*create_friendly_id_slugs.rb").first }

        gsub_file friendly_id_migration, /create_table.*?end(?=\n)/m, <<~RUBY.chomp.lines.map(&:chomp).join("\n    ")
          create_table :friendly_id_slugs, id: :string, default: -> { "uuid()" }, limit: 36 do |t|
            t.string :slug, null: false
            t.string :sluggable_id, limit: 36, null: false
            t.string :sluggable_type, limit: 50
            t.string :scope
            t.datetime :created_at
          end
          add_index :friendly_id_slugs, [ :sluggable_type, :sluggable_id ]
          add_index :friendly_id_slugs, [ :slug, :sluggable_type ], length: { slug: 140, sluggable_type: 50 }
          add_index :friendly_id_slugs, [ :slug, :sluggable_type, :scope ], length: { slug: 70, sluggable_type: 50, scope: 70 }, unique: true
        RUBY
      end

      def setup_avo
        rails_command "g avo:install", skip_routes: true
      end

      def migrate_and_cleanup_db
        rails_command "db:migrate"
        rails_command "db:drop"
      end

      # TODO: add docs

    end
  end
end
