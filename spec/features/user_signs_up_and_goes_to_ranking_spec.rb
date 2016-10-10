require 'rails_helper'

RSpec.feature "User signs up and goes to ranking", type: :feature do
  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category)])}

  background do
    sign_in
    expect(page).to have_content 'Wyloguj się'
  end

  scenario 'when signed in', js: true do
    click_link "Ranking"
    expect(page).to have_content("Ranking")
  end

end
