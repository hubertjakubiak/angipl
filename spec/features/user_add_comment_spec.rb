require 'spec_helper'

RSpec.feature "User add comment", type: :feature do

  background do
    
    10.times { word = FactoryGirl.create(:word) }

    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit game_words_path
  end


  scenario 'when sign in' do
    visit word_path(id: 1)
    fill_in 'Treść komentarza:', with: 'Taki tam komentarz'

    expect(page).to have_content 'Taki tam komentarz'

  end

  scenario 'when sign out' do
    logout
    visit word_path(id: 1)

    expect(page).not_to have_content 'Treść komentarza:'

  end

end