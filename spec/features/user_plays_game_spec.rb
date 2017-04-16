require 'rails_helper'

RSpec.feature "User plays game", type: :feature do
  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category)])}

  scenario 'when signed in and select answer', js: true do
    sign_in
    visit root_path
    click_button('Pokaż odpowiedzi')
    first('.word.btn-default').click
    #click_button("cat", visible: false);
    page.has_css?('.word')
    expect(page).to have_css('.word.btn-success')
    expect(page).not_to have_content("Wystąpił błąd")
  end



  scenario 'when signed out and select answer', js: true do
    visit root_path
    click_button('Pokaż odpowiedzi')
    first('.word.btn-default').click
    #click_button("cat", visible: false);
    page.has_css?('.word')
    expect(page).to have_css('.word.btn-success')
    expect(page).not_to have_content("Wystąpił błąd")
  end

   scenario 'when signed in', js: true do
    visit root_path
    find('#select-game-option').find(:xpath, 'option[text()[contains(.,"Chcę wpisywać")]]').click
    expect(page).to have_content('Sprawdź')
    expect(current_url).to include('typing=true')

    click_button "Sprawdź"
    expect(page).to have_css(".wrong-answer")
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
