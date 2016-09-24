require 'spec_helper'

RSpec.feature "User can only edit his words ", type: :feature do

  let!(:word) {FactoryGirl.create_list(:word, 10, user_id: 2, :categories => [FactoryGirl.create(:category)])}

  before(:each) do
    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit root_path
    click_link('Dodaj słówko')
  end

  scenario 'with valid input' do
    fill_in 'Angielski', with: Faker::Lorem.word
    fill_in 'Polski', with: Faker::Lorem.word
    find(:css, ".check_boxes[value='1']").set(true)
    click_button 'Zapisz'
    expect(page).to have_content 'Słówko zostało prawidłowo zapisane.'

    visit edit_word_path(1)

    expect(page).to have_content 'Nie możesz edytować tego słówka.'
  end

end