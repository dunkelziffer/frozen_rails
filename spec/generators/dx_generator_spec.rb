# frozen_string_literal: true

require "spec_helper"
require "rails/generators"
require "generators/frozen/dx_generator"

RSpec.describe Frozen::Generators::DxGenerator do
  it "is registered under the frozen namespace" do
    expect(Frozen::Generators::DxGenerator).to be_a(Class)
  end
end
