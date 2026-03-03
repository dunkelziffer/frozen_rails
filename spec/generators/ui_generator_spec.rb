# frozen_string_literal: true

require "spec_helper"
require "rails/generators"
require "generators/frozen/ui_generator"

RSpec.describe Frozen::Generators::UiGenerator do
  it "is registered under the frozen namespace" do
    expect(Frozen::Generators::UiGenerator).to be_a(Class)
  end
end
