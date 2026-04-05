require "rails/generators"
require "frozen_rails/taggable"

module Frozen
  module Generators
    class RailsGenerator < Rails::Generators::Base
      include Taggable

      desc "Run all frozen setup generators (md, ssg, db, ui, seo)"

      def run_all
        say_status :info, "invoking frozen:md"
        invoke "frozen:md", [], cleanup_frozen_tags: false

        say_status :info, "invoking frozen:ssg"
        invoke "frozen:ssg", [], cleanup_frozen_tags: false

        say_status :info, "invoking frozen:db"
        invoke "frozen:db", [], cleanup_frozen_tags: false

        say_status :info, "invoking frozen:ui"
        invoke "frozen:ui", [], cleanup_frozen_tags: false

        # say_status :info, "invoking frozen:seo"
        # invoke "frozen:seo", [], cleanup_frozen_tags: false

        cleanup_all_frozen_tags!
      end
    end
  end
end
