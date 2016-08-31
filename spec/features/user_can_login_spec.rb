require 'spec_helper'

RSpec.feature "User", type: :feature do

  before(:each) do

    category = FactoryGirl.create(:category)
    
    10.times { word = FactoryGirl.create(:word) }

  end

  scenario 'can login' do

    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit game_words_path
    expect(page).to have_content 'Pokaż odpowiedzi'
  end

end