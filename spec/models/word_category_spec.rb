require 'rails_helper'

RSpec.describe WordCategory, type: :model do
  it { is_expected.to belong_to :category}
  it { is_expected.to belong_to :word}
end
