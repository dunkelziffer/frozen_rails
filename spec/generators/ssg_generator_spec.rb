# frozen_string_literal: true

require "spec_helper"
require "rails/generators"
require "generators/frozen/ssg_generator"

RSpec.describe Frozen::Generators::SsgGenerator do
  it "is registered under the frozen namespace" do
    expect(Frozen::Generators::SsgGenerator).to be_a(Class)
  end
end
