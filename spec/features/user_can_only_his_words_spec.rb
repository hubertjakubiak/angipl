require 'spec_helper'

RSpec.feature "User can ", type: :feature do


  before(:each) do

    category = FactoryGirl.create(:category)
    
    10.times { word = FactoryGirl.create(:word) }

    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit game_words_path
    click_link('Dodaj słówko')
  end

  scenario 'with valid input' do
    fill_in 'Angielski', with: Faker::Lorem.word
    fill_in 'Polski', with: Faker::Lorem.word
    find(:css, ".check_boxes[value='1']").set(true)
    click_button 'Zapisz'
    expect(page).to have_content 'Słówko zostało prawidłowo zapisane.'
  end

end