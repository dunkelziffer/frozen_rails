module Appendable
  extend ActiveSupport::Concern

  private

  def append_to_application_config(data)
    inject_into_file "config/application.rb", optimize_indentation(data, 4), before: /  end\nend(?:\n)\z/, verbose: false
  end

  def append_to_routes(data)
    inject_into_file "config/routes.rb", optimize_indentation(data, 2), before: /end(?:\n)\z/, verbose: false
  end

end
