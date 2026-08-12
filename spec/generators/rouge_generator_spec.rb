require "generators/frozen/rouge_generator"

RSpec.describe Frozen::Generators::RougeGenerator do
  it "is registered under the frozen namespace" do
    expect(Frozen::Generators::RougeGenerator).to be_a(Class)
  end
end
