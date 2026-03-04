# frozen_string_literal: true

require "spec_helper"
require "rails/generators"
require "generators/frozen/md_generator"

RSpec.describe Frozen::Generators::MdGenerator do
  it "is registered under the frozen namespace" do
    expect(Frozen::Generators::MdGenerator).to be_a(Class)
  end

  describe "rouge theme support" do
    let(:generator) do
      described_class.new([], generator_opts, strict: false)
    end

    before do
      allow(generator).to receive(:run)
    end

    context "when --rouge_theme is provided" do
      let(:generator_opts) { {"rouge_theme" => "monokai"} }

      it "uses the supplied theme without prompting" do
        expect(generator).to_not receive(:ask)
        expect(generator).to receive(:run).with("rougify style monokai > app/assets/stylesheets/rouge.css")
        generator.generate_rouge_css_hint
      end
    end

    context "when no option is provided" do
      let(:generator_opts) { {} }

      it "prompts the user and uses their answer" do
        # backtick call returns a small list of themes
        allow(generator).to receive(:`).and_return("github\n")
        allow(generator).to receive(:ask).and_return("github")
        expect(generator).to receive(:run).with("rougify style github > app/assets/stylesheets/rouge.css")
        generator.generate_rouge_css_hint
      end
    end
  end
end
