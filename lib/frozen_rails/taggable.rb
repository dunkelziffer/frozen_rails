module Taggable
  extend ActiveSupport::Concern

  included do
    class_option :cleanup_frozen_tags, type: :boolean, default: true, hide: true
  end

  private

  def add_frozen_gems(content, env: nil)
    add_frozen_gemfile_tags(env:)
    insert_into_file "Gemfile", optimize_indentation("#{content}\n", env ? 2 : 0), before: frozen_end_tag(env:)
    cleanup_frozen_tags!(env:)
  end

  def frozen_start_tag(env: nil)
    env_attribute = env ? " env=\"#{env}\"" : ""
    "# <frozen_rails#{env_attribute}>"
  end

  def frozen_end_tag(env: nil)
    frozen_start_tag(env:).gsub("# <", "# </")
  end

  def add_frozen_gemfile_tags(env: nil)
    unless File.read("Gemfile").include?(frozen_start_tag(env:))
      space_between = env ? "\n" : "\n\n"
      space_after = env ? "\n" : ""
      tags = "#{frozen_start_tag(env:)}#{space_between}#{frozen_end_tag(env:)}#{space_after}"
      insert_into_file "Gemfile", tags, after: frozen_tags_after(env:)
    end
  end

  def frozen_tags_after(env: nil)
    case env
    when nil
      /frozen_rails[^\n]*\n/
    when "local"
      "group :development, :test do\n"
    when "development"
      "group :development do\n"
    else
      raise "Unsupported env!"
    end
  end

  def cleanup_frozen_tags!(env: nil)
    if options[:cleanup_frozen_tags]
      gsub_file! "Gemfile", /[^\n]*#{frozen_start_tag(env:)}[^\n]*\n/, ""
      gsub_file! "Gemfile", /[^\n]*#{frozen_end_tag(env:)}[^\n]*\n/, ""
    end
  end

  def cleanup_all_frozen_tags!
    cleanup_frozen_tags!
    cleanup_frozen_tags!(env: "local")
    cleanup_frozen_tags!(env: "development")
  end
end
