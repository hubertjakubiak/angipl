require 'spec_helper'

RSpec.feature "User goes to rankings users", js: true, type: :feature do

  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category)])}

  scenario 'when no stats' do
    visit rankings_users_path
    expect(page).to have_content("Brak danych.")
  end

  scenario 'when signed in' do
    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit root_path
    click_button('Pokaż odpowiedzi')
    first('.word.btn-default').click
    expect(page).not_to have_content("Wystąpił błąd")
    visit rankings_users_path
    expect(page).to have_css("h1", text: "Ranking")
  end

  scenario 'after logout' do
    sign_in
    expect(page).to have_content 'Wyloguj się'
    logout
    visit rankings_users_path
    expect(page).to have_css("h1", text: "Ranking")
  end

end