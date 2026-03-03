# frozen_string_literal: true

require "spec_helper"
require "rails/generators"
require "generators/frozen/seo_generator"

RSpec.describe Frozen::Generators::SeoGenerator do
  it "is registered under the frozen namespace" do
    expect(Frozen::Generators::SeoGenerator).to be_a(Class)
  end
end
