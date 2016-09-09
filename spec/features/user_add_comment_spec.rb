require 'spec_helper'

RSpec.feature "User add comment", type: :feature do

  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category)])}
  let!(:user) {FactoryGirl.create(:user)}

  background do
    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit game_words_path
  end


  scenario 'when sign in', js: true do
    visit word_path(id: 1)
    fill_in 'Treść komentarza:', with: 'Taki tam komentarz'
    click_button('Dodaj komentarz')
    expect(page).to have_content 'Taki tam komentarz'

  end

  scenario 'when sign in and empty comment' do
    visit word_path(id: 1)
    fill_in 'Treść komentarza:', with: ''
    click_button('Dodaj komentarz')
    expect(page).to have_content 'To pole nie może być puste'

  end

  scenario 'when sign out' do
    logout
    visit word_path(id: 1)

    expect(page).not_to have_content 'Treść komentarza:'

  end

end