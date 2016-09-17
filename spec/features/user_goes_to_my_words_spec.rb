require 'spec_helper'

RSpec.feature "User goes to my words", type: :feature do

  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category)])}
  let!(:user) {FactoryGirl.create(:user)}
  
  background do

    sign_in
    expect(page).to have_content 'Wyloguj się'
  end

  scenario 'normal' do
    visit game_words_path
    click_link('Moje słówka')
    expect(page).to have_css("h1", text: "Moje słówka")
  end

end