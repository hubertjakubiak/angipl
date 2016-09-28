require 'spec_helper'

RSpec.feature "User goes to contact page", type: :feature do

  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category)])}
  let!(:user) {FactoryGirl.create(:user)}

  background do
    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit root_path
  end


  scenario 'when signed in' do
    click_link('Kontakt')
    expect(page).to have_css("h1", text: "Kontakt")
  end

  scenario 'when signed out' do
    logout
    click_link('Kontakt')
    expect(page).to have_css("h1", text: "Kontakt")

  end

end