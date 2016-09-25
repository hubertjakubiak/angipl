require 'spec_helper'

RSpec.feature "User access my words", type: :feature do

  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category)])}
  let!(:user) {FactoryGirl.create(:user)}
  
  background do

    sign_in
    expect(page).to have_content 'Wyloguj się'
  end

  scenario 'when signed in' do
    visit root_path
    click_link('Moje słówka')
    expect(page).to have_css("h1", text: "Moje słówka")
  end

  scenario 'after logout' do
    logout
    visit my_words_path
    expect(page).to have_content("Musisz się zalogować, aby mieć swoje słówka.")
  end

end