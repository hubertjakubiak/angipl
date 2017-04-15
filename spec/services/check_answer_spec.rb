require "rails_helper"

describe CheckAnswer do

  shared_context "when there are some words" do
    let!(:word) { create(:word, en: "cat", pl: "kot") }
  end

  shared_examples "returns count of matched translations" do |value|
    it "returns count of matched translations" do
      expect(subject).to eq value
    end
  end

  shared_examples "returns string" do
    it "returns string" do
      expect(subject.class).to eq String
    end
  end

  context "when there are some words" do
    include_context "when there are some words"
    context "when translation is correct" do
      subject { described_class.new(en: "cat", pl: "kot").call }
      
      include_examples "returns count of matched translations", "1"
      include_examples "returns string"
    end

    context "when translation is not correct" do
      subject { described_class.new(en: "cat", pl: "pies").call }

      include_examples "returns count of matched translations", "0"
      include_examples "returns string"
    end

    context "when translation is not found" do
      subject { described_class.new(en: "dog", pl: "pies").call }
      
      include_examples "returns count of matched translations", "0"
      include_examples "returns string"
    end
  end

  context "when there aren't any words" do
    context "when translation is correct" do
      subject { described_class.new(en: "cat", pl: "kot").call }
      
      include_examples "returns count of matched translations", "0"
      include_examples "returns string"
    end

    context "when translation is not correct" do
      subject { described_class.new(en: "cat", pl: "pies").call }

      include_examples "returns count of matched translations", "0"
      include_examples "returns string"
    end

    context "when translation is not found" do
      subject { described_class.new(en: "dog", pl: "pies").call }
      
      include_examples "returns count of matched translations", "0"
      include_examples "returns string"
    end
  end
end
