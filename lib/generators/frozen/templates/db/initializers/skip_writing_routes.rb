ActiveSupport.on_load(:after_initialize) do
  require "rails/generators"
  require "rails/generators/erb/scaffold/scaffold_generator"

  Erb::Generators::ScaffoldGenerator.prepend(
    Module.new do
      private

      def available_views
        [ "index", "show" ]
      end
    end
  )
end
