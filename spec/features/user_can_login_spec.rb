require 'spec_helper'

RSpec.feature "User", type: :feature do

  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category)])}
  let!(:user) {FactoryGirl.create(:user)}

  scenario 'can login' do

    sign_in
    expect(page).to have_content 'Wyloguj się'
    visit game_words_path
    expect(page).to have_content 'Pokaż odpowiedzi'
  end

end