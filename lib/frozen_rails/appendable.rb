module Appendable
  extend ActiveSupport::Concern

  private

  def append_to_application_config(content)
    inject_into_file "config/application.rb", optimize_indentation("\n#{content}", 4), before: /  end\nend(?:\n)\z/, verbose: false
  end

  def append_to_routes(content)
    inject_into_file "config/routes.rb", optimize_indentation("\n#{content}", 2), before: /end(?:\n)\z/, verbose: false
  end

end
