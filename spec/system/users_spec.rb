require 'rails_helper'

RSpec.describe "Users", type: :system, js: true do
  describe 'sign up' do
    let(:user) { build :user }

    it 'valid sign up' do
      visit root_path

      expect(page).to have_link '新規登録'

      click_link '新規登録'

      expect(current_path).to eq new_user_registration_path

      expect(page).to have_button 'signup', disabled: true

      fill_in 'user[username]', with: user.username
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      fill_in 'user[password_confirmation]', with: user.password_confirmation

      expect{ click_button 'signup' }.to change { User.count }.by(1)

      expect(page).to have_content 'アカウント登録が完了しました。'
    end
  end
end
