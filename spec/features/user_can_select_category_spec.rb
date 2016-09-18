require 'rails_helper'

RSpec.feature "User can select category", type: :feature do
  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category, name: 'Biznes')])}
  let!(:category) {FactoryGirl.create(:category, name: 'Sport')}

  background do
    sign_in
    visit root_path
  end

  scenario 'that exists and have words', js: true do
    find('#select-category').find(:xpath, 'option[text() = "Biznes"]').click
    expect(page).to have_content('Biznes')
    expect(page).to have_current_path(root_path(category: 'Biznes'))
  end

  scenario 'that exists but does not have words', js: true do
    find('#select-category').find(:xpath, 'option[text() = "Sport"]').click
    expect(page).to have_content('Kategoria musi zawierać minimum 5 słówek.')
    expect(page).to have_current_path(root_path)
  end

end
