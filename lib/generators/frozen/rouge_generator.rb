require "frozen_rails/generator"

module Frozen
  module Generators
    class RougeGenerator < FrozenRails::Generator
      source_root File.expand_path("templates/rouge", __dir__)

      # When absent, the generator will prompt interactively (unless running non-interactively).
      class_option :rouge_theme, type: :string, desc: "Rouge theme to install (runs non-interactive if provided)"

      desc "Generate the chosen rouge theme in the correct location"

      def generate_rouge_css_stylesheet
        theme = options[:rouge_theme]

        if theme.blank? && behavior == :invoke && $stdin.tty?
          # Run in subshell so we pick up newly installed gem without needing to require it in the current process.
          themes = `bundle exec ruby -e "require 'rouge'; puts Rouge::Theme.registry.keys.sort"`.split("\n")

          say_status :info, "Available Rouge themes (#{themes.size}):", :blue
          themes.each_with_index { |t, i| say "  #{i + 1}. #{t}" }

          answer = ask("Choose a theme (name or number) [github]")

          theme = if /^\d+$/.match?(answer)
            themes[answer.to_i - 1]
          else
            answer.presence
          end
        end

        theme ||= "github"

        say_status :info, "Generating Rouge CSS for theme #{theme}", :blue
        run "rougify style #{theme} > app/assets/rouge/rouge.css"
      end
    end
  end
end
