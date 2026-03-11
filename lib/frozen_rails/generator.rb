# frozen_string_literal: true

require "rails/generators"
require "frozen_rails/appendable"
require "frozen_rails/bundleable"
require "frozen_rails/taggable"

module FrozenRails
  class Generator < Rails::Generators::Base
    include Appendable
    include Bundleable
    include Taggable
  end
end
