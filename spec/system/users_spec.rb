require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'sign up' do
    let(:user) { build :user }

    it 'valid sign up', js: true do
      visit root_path

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

  describe 'sign in' do
    let(:user) { create :user }

    it 'valid sign in', js: true do
      visit root_path

      within '.container' do
        click_link 'ログイン'
      end

      expect(current_path).to eq new_user_session_path

      expect(page).to have_button 'signin', disabled: true

      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password

      click_button 'signin'

      expect(page).to have_content 'ログインしました。'
    end
  end

  it 'guest sign in' do
    visit root_path

    click_link 'ゲストユーザーとしてログイン'

    expect(page).to have_content 'ゲストユーザーとしてログインしました。'
  end

  describe 'edit profile' do
    context 'signed in as wrong user' do
      let(:user) { create :user, username: 'user' }
      let(:other_user) { create :user, username: 'other_user' }

      it 'redirect edit', js: true do
        sign_in other_user

        visit edit_user_path(user)

        expect(page).to have_content '権限がありません。'
      end
    end
  end

  describe 'edit user' do
    let(:user) { create :user, email: 'before@example.com' }

    it 'successful edit', js: true do
      sign_in user
      find('.is-hoverable').hover
      click_link 'アカウント編集'
      expect(current_path).to eq edit_user_registration_path
      expect(page).to have_button 'update_account', disabled: true
      fill_in 'user[email]', with: 'after@example.com'
      fill_in 'user[current_password]', with: user.password
      click_button 'update_account'
      expect(user.reload.email).to eq 'after@example.com'
      expect(page).to have_content 'アカウント情報を変更しました。'
    end
  end
end
