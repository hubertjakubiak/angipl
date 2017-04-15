require "rails_helper"

describe CheckAnswer do
  let!(:word) { create(:word, en: "cat", pl: "kot") }

  shared_examples "returns count of matched translations" do |value|
    it "returns count of matched translations" do
      expect(subject).to eq value
    end

    it "returns string" do
      expect(subject.class).to eq String
    end
  end

  context "when translation is correct" do
    subject { described_class.new(en: "cat", pl: "kot").call }
    
    include_examples "returns count of matched translations", "1"
  end

  context "when translation is not correct" do
    subject { described_class.new(en: "cat", pl: "pies").call }

    include_examples "returns count of matched translations", "0"
  end

  context "when translation is not found" do
    subject { described_class.new(en: "dog", pl: "pies").call }
    
    include_examples "returns count of matched translations", "0"
  end
end
