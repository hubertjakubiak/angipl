require 'spec_helper'

RSpec.feature "User does not see import option", type: :feature do

  let!(:word) { create_list(:word, 10, categories: [create(:category)]) }

  background do
    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit root_path
    click_link('Dodaj słówko')
  end

  scenario 'when signed in' do
    expect(page).not_to have_content 'Importuj słówka'
  end

  scenario 'when signed in and he is admin' do
    User.last.update(admin: true)
    click_link('Dodaj słówko')
    expect(page).to have_content 'Importuj słówka'
  end

  scenario 'when signed out' do
    logout
    expect(page).not_to have_content 'Importuj słówka'
  end

end
