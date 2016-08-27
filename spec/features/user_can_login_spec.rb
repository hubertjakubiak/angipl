require 'spec_helper'

feature 'User can login' do

  before(:all) do

    category = FactoryGirl.create(:category)
    
    10.times { word = FactoryGirl.create(:word) }

  end

  it 'user can login' do

    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit game_words_path
    expect(page).to have_content 'Pokaż odpowiedzi'
  end

end