require 'spec_helper'

RSpec.feature "User create word", type: :feature do

  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category)])}
  let!(:user) {FactoryGirl.create(:user)}
  
  background do

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
  end

  scenario 'with missing en value' do
    fill_in 'Polski', with: Faker::Lorem.word
    find(:css, ".check_boxes[value='1']").set(true)
    click_button 'Zapisz'
    expect(page).to have_content 'To pole nie może być puste'
  end

  scenario 'with missing pl value' do
    fill_in 'Angielski', with: Faker::Lorem.word
    find(:css, ".check_boxes[value='1']").set(true)
    click_button 'Zapisz'
    expect(page).to have_content 'To pole nie może być puste'
  end

  scenario 'with missing category' do
    fill_in 'Angielski', with: Faker::Lorem.word
    fill_in 'Polski', with: Faker::Lorem.word
    click_button 'Zapisz'
    expect(page).to have_content 'Musisz wybrać kategorię'
  end

  scenario 'try add the same word twice' do
    fill_in 'Angielski', with: 'cat'
    fill_in 'Polski', with: 'kot'
    find(:css, ".check_boxes[value='1']").set(true)
    click_button 'Zapisz'
    expect(page).to have_content 'Słówko zostało prawidłowo zapisane.'

    click_link('Dodaj słówko')

    fill_in 'Angielski', with: 'cat'
    fill_in 'Polski', with: 'kot'
    find(:css, ".check_boxes[value='1']").set(true)
    click_button 'Zapisz'
    expect(page).to have_content 'Istnieje już takie tłumaczenie'    
  end

  scenario 'strip word if add unnecessary spaces' do
    fill_in 'Angielski', with: '   cat'
    fill_in 'Polski', with: 'kot'
    find(:css, ".check_boxes[value='1']").set(true)
    click_button 'Zapisz'
    expect(page).to have_content 'Słówko zostało prawidłowo zapisane.'
    en_word = Word.last.en
    expect(en_word).to eq('cat')
  end

end