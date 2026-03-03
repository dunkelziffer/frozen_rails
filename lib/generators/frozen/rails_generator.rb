# frozen_string_literal: true

require "rails/generators"

module Frozen
  module Generators
    # A meta-generator that runs the other frozen generators in a sensible order.
    class RailsGenerator < Rails::Generators::Base
      desc "Run all frozen setup generators (md, db, seo, ui, dx, ssg)"

      # The method name doesn't matter much; Thor runs all public methods in
      # order defined by source.
      def run_all
        say_status :info, "invoking frozen:md"
        invoke "frozen:md"

        say_status :info, "invoking frozen:db"
        invoke "frozen:db"

        say_status :info, "invoking frozen:seo"
        invoke "frozen:seo"

        say_status :info, "invoking frozen:ui"
        invoke "frozen:ui"

        say_status :info, "invoking frozen:dx"
        invoke "frozen:dx"

        say_status :info, "invoking frozen:ssg"
        invoke "frozen:ssg"
      end
    end
  end
end
