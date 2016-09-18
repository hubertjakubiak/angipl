require 'rails_helper'

RSpec.feature "User", type: :feature do
  let!(:word) {FactoryGirl.create_list(:word, 10, :categories => [FactoryGirl.create(:category, name: 'Biznes')])}

  background do
    sign_in
    visit root_path
  end

  scenario 'can select category', js: true do
    find('#select-category').find(:xpath, 'option[text() = "Biznes"]').click
    expect(page).to have_content('Biznes')
    expect(page).to have_current_path(root_path(category: 'Biznes'))
  end

end
