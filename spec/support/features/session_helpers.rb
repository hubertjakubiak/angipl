
module Features
  module SessionHelpers
    def sign_up_with(email, password)
      visit new_user_registration_path
      fill_in 'Adres e-mail', with: email
      fill_in 'Hasło', with: password
      fill_in 'Potwierdź hasło', with: password
      within(".form-actions") do
        click_on 'Zarejestruj się'
      end
    end

    def sign_in
      user = FactoryGirl.create(:user)
      visit new_user_session_path
      fill_in 'Adres e-mail', with: user.email
      fill_in 'Hasło', with: user.password
      click_button 'Zaloguj się'
    end

    def logout
      click_on 'Wyloguj się'
    end
  end
end