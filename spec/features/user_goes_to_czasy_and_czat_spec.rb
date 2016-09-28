require 'spec_helper'

RSpec.feature "User goes to czasy and czat", type: :feature do

  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category)])}
  let!(:user) {FactoryGirl.create(:user)}

  background do
    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit root_path
  end


  scenario 'when signed in' do
    visit '/czasy'
    expect(page).to have_content 'Wybierz prawidłowe tłumaczenie.'
    visit '/czat'
    expect(page).to have_content 'Wybierz prawidłowe tłumaczenie.'
  end

  scenario 'when signed out' do
    logout
    visit '/czasy'
    expect(page).to have_content 'Wybierz prawidłowe tłumaczenie.'
    visit '/czat'
    expect(page).to have_content 'Wybierz prawidłowe tłumaczenie.'

  end

end