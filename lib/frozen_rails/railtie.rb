# frozen_string_literal: true

module FrozenRails # :nodoc:
  class Railtie < ::Rails::Railtie # :nodoc:
    generators do
      require_relative "../generators/frozen/md_generator"
    end
  end
end
