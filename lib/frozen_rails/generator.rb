# frozen_string_literal: true

require "rails/generators"
require "frozen_rails/taggable"
require "frozen_rails/bundleable"

module FrozenRails
  class Generator < Rails::Generators::Base
    include Taggable
    include Bundleable
  end
end
