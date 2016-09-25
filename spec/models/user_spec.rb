require 'rails_helper'

RSpec.describe User do

  describe 'associations' do
    it { is_expected.to have_many :words }
    it { is_expected.to have_one :stat }
    it { is_expected.to have_one :setting }
  end
end