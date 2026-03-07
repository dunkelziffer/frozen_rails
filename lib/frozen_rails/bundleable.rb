module Bundleable
  extend ActiveSupport::Concern

  private

  def bundle!
    Bundler.with_unbundled_env do
      system "bundle install"
    end
  end
end
