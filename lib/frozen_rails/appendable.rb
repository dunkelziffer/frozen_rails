module Appendable
  extend ActiveSupport::Concern

  private

  def append_to_application_config(content, env: nil)
    case env
    when nil
      inject_into_file "config/application.rb", optimize_indentation("\n#{content}", 4), before: /  end\nend(?:\n)\z/, verbose: false
    when "development", "production", "test"
      inject_into_file "config/environments/#{env}.rb", optimize_indentation("\n#{content}", 2), before: /end(?:\n)\z/, verbose: false
    else
      raise "Unknown env: #{env}"
    end
  end

  def append_to_routes(content)
    inject_into_file "config/routes.rb", optimize_indentation("\n#{content}", 2), before: /end(?:\n)\z/, verbose: false
  end
end
