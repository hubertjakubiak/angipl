require 'spec_helper'

RSpec.feature "User", type: :feature do

  it "has ability to create word" do
      user = FactoryGirl.create(:user)
      ability = Ability.new(user)
      word = Word.new(user: user)
      expect { ability.should be_able_to(:create, word)}
  end
end