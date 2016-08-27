require 'spec_helper'
require "cancan/matchers"

feature 'User creates word' do


  before(:all) do

    category = FactoryGirl.create(:category)
    
    10.times { word = FactoryGirl.create(:word) }

    puts Word.verified.size

    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit game_words_path
    click_link('Dodaj słówko')
  end

  scenario 'with valid input' do
    fill_in 'Angielski', with: 'house'
    fill_in 'Polski', with: 'dom'
    find(:css, ".check_boxes[value='1']").set(true)
    click_button 'Zapisz'
    expect(page).to have_content 'Słówko zostało prawidłowo zapisane.'
  end

  it 'user can login' do

    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit game_words_path
    expect(page).to have_content 'Pokaż odpowiedzi'
  end

  it "user has ability to create word" do
        user = FactoryGirl.create(:user)
        ability = Ability.new(user)
        word = Word.new(user: user)
        expect { ability.should be_able_to(:create, word)}
    end

end