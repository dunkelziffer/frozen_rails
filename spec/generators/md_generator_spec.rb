# frozen_string_literal: true

require "spec_helper"
require "rails/generators"
require "generators/frozen/md_generator"

RSpec.describe Frozen::Generators::MdGenerator do
  it "is registered under the frozen namespace" do
    expect(Frozen::Generators::MdGenerator).to be_a(Class)
  end
end
