# frozen_string_literal: true

require "spec_helper"
require "rails/generators"
require "generators/frozen/rails_generator"

RSpec.describe Frozen::Generators::RailsGenerator do
  it "is registered under the frozen namespace" do
    expect(Frozen::Generators::RailsGenerator).to be_a(Class)
  end
end
