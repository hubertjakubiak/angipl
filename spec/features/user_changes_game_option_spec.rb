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
    expect(current_url).to include('typing=true')
    find('#select-game-option').find(:xpath, 'option[text()[contains(.,"Chcę wybierać")]]').click
    expect(page).to have_content('Pokaż odpowiedzi')
    expect(current_path).to eql(root_path)
  end

  scenario 'when signed out', js: true do
    logout
    find('#select-game-option').find(:xpath, 'option[text()[contains(.,"Chcę wpisywać")]]').click
    expect(page).to have_content('Sprawdź')
    expect(current_url).to include('typing=true')

    find('#select-game-option').find(:xpath, 'option[text()[contains(.,"Chcę wybierać")]]').click
    expect(page).to have_content('Pokaż odpowiedzi')
    expect(current_url).to_not include('typing=true')
  end


end
