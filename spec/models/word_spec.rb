require 'rails_helper'

RSpec.describe Word do
  describe 'validations' do
    it { is_expected.to validate_presence_of :en }
    it { is_expected.to validate_presence_of :pl }
    it { should validate_uniqueness_of(:en).scoped_to(:pl) }
    it { should validate_uniqueness_of(:pl).scoped_to(:en) }
    it { is_expected.to validate_presence_of :categories }
  end

  describe 'database columns' do
    it { should have_db_column :en }
    it { should have_db_column :pl }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :categories }
    it { is_expected.to have_many :word_categories }
  end
end