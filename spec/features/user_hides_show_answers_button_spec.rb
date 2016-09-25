require 'spec_helper'

RSpec.feature "User hides show anwsers buton", js: true, type: :feature do

  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category)])}
  let!(:user) {FactoryGirl.create(:user)}
  
  background do

    sign_in
    expect(page).to have_content 'Wyloguj się'
  end

  scenario 'when signed in' do
    visit settings_path
    expect(page).to have_content("Ustawienia")
    find("input[id='setting_hide_show_answers_button']").click
    click_button('Zapisz')
    expect(page).to have_content("Ustawienia zostały zapisane.")
    visit root_path
    expect(page).not_to have_content("Pokaż odpowiedzi")

    visit settings_path
    expect(page).to have_content("Ustawienia")
    find("input[id='setting_hide_show_answers_button']").click
    click_button('Zapisz') 
    expect(page).to have_content("Ustawienia zostały zapisane.")
    visit root_path
    expect(page).to have_content("Pokaż odpowiedzi")
  end

  scenario 'when signed out' do
    logout
    visit settings_path
    expect(page).to have_content("Musisz się zalogować, aby edytować ustawienia.")
  end

end