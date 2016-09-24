require 'rails_helper'

RSpec.feature "User plays game", type: :feature do
  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category)])}

  background do
    sign_in
    visit root_path
  end

  scenario 'and select answer', js: true do
    click_button('Pokaż odpowiedzi')
    first('.word.btn-default').click
    #click_button("cat", visible: false);
    page.has_css?('.word')
    expect(page).to have_css('.word.btn-success')
  end

  # scenario 'and select good answer', js: true do
  #   click_button('Pokaż odpowiedzi')
  #   find('.word[data-word="cat"]').click
  #   #click_button("cat", visible: false);
  #   expect(page).to have_css('.word[data-word="cat"].btn-success')
  # end

  # scenario 'and select correct bad answer', js: true do
  #   click_button('Pokaż odpowiedzi')
  #   find('.word[data-word="dog"]').click
  #   #click_button("cat", visible: false);
  #   expect(page).to have_css('.word[data-word="dog"].btn-danger')
  # end

end
