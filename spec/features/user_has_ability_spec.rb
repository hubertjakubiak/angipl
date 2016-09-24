require 'spec_helper'

RSpec.feature "User has ability", type: :feature do

  it "to create new word" do
      user = FactoryGirl.create(:user)
      ability = Ability.new(user)
      word = Word.new(user: user)
      expect { ability.should be_able_to(:create, word)}
  end
end