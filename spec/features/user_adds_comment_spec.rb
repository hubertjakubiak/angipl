require 'spec_helper'

RSpec.feature "User adds comment", type: :feature do
  
  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category)])}
  let!(:user) {FactoryGirl.create(:user)}

  before do
    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit root_path
  end


  it 'when signed in' do
    visit word_path(id: 1)
    fill_in 'Treść komentarza:', with: 'Taki tam komentarz'
    click_button('Dodaj komentarz')
    expect(page).to have_content 'Taki tam komentarz'

  end

  it 'when signed in and try to add empty comment' do
    visit word_path(id: 1)
    fill_in 'Treść komentarza:', with: ''
    click_button('Dodaj komentarz')
    expect(page).to have_content 'To pole nie może być puste'

  end

  it 'when signed out' do
    logout
    visit word_path(id: 1)

    expect(page).to have_content 'Zaloguj się, aby dodać komentarz'

  end

end