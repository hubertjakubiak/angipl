require 'rails_helper'

RSpec.feature "User changes games option", type: :feature do
  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category, name: 'Biznes')])}

  background do
    sign_in
    visit root_path
  end

  scenario 'when signed in', js: true do
    find('#select-game-option').find(:xpath, 'option[text()[contains(.,"Chcę wpisywać")]]').click
    expect(page).to have_content('Sprawdź')
    expect(page).to have_current_path(root_path(typing: 'true'))

    find('#select-game-option').find(:xpath, 'option[text()[contains(.,"Chcę wybierać")]]').click
    expect(page).to have_content('Pokaż odpowiedzi')
    expect(page).to have_current_path(root_path)
  end

  scenario 'when signed out', js: true do
    logout
    find('#select-game-option').find(:xpath, 'option[text()[contains(.,"Chcę wpisywać")]]').click
    expect(page).to have_content('Sprawdź')
    expect(page).to have_current_path(root_path(typing: 'true'))

    find('#select-game-option').find(:xpath, 'option[text()[contains(.,"Chcę wybierać")]]').click
    expect(page).to have_content('Pokaż odpowiedzi')
    expect(page).to have_current_path(root_path)
  end


end
