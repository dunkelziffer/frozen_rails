require "rails/generators"
require "frozen_rails/appendable"
require "frozen_rails/bundleable"
require "frozen_rails/copyable"
require "frozen_rails/taggable"

module FrozenRails
  class Generator < Rails::Generators::Base
    include Appendable
    include Bundleable
    include Copyable
    include Taggable
  end
end
