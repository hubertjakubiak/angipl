require 'spec_helper'

RSpec.feature "User can only edit his words ", type: :feature do

  let!(:word) {FactoryGirl.create_list(:word, 10, user_id: 2, :categories => [FactoryGirl.create(:category)])}

  before(:each) do
    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit root_path
    click_link('Dodaj słówko')
  end

  scenario 'that belongs to him' do
    fill_in 'Angielski', with: 'cat'
    fill_in 'Polski', with: 'kot'
    find(:css, ".check_boxes[value='1']").set(true)
    click_button 'Zapisz'
    expect(page).to have_content I18n.t("messages.word_was_saved")

    visit edit_word_path(11)

    fill_in 'Angielski', with: 'cat'
    fill_in 'Polski', with: 'kotek'
    click_button 'Zapisz'

    visit word_path(11)

    expect(page).to have_content 'kotek'
  end

  scenario 'that does not belong to him' do
    visit edit_word_path(1)
    expect(page).to have_content I18n.t("messages.you_cant_edit_this_word")
  end

end
