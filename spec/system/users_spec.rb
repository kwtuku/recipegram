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

  describe 'edit account' do
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

  describe 'edit user' do
    context 'signed in as wrong user' do
      let(:user) { create :user, username: 'user' }
      let(:other_user) { create :user, username: 'other_user' }

      it 'can not edit', js: true do
        sign_in other_user
        visit edit_user_path(user)
        expect(current_path).to eq user_path(user)
        expect(page).to have_content '権限がありません。'
      end
    end

    context 'signed in as correct user' do
      let(:user) { create :user, username: 'user', profile: 'プロフィールです。' }

      it 'edit username', js: true do
        sign_in user
        find('.is-hoverable').hover
        click_link 'マイページ'
        expect(current_path).to eq user_path(user)
        click_link 'プロフィールを編集'
        expect(page).to have_button 'update_user', disabled: true
        fill_in 'user[username]', with: 'user ver.2'
        click_button 'update_user'
        expect(user.reload.username).to eq 'user ver.2'
        expect(page).to have_content 'プロフィールを変更しました。'
      end

      it 'edit profile', js: true do
        sign_in user
        find('.is-hoverable').hover
        click_link 'マイページ'
        expect(current_path).to eq user_path(user)
        click_link 'プロフィールを編集'
        expect(page).to have_button 'update_user', disabled: true
        fill_in 'user[profile]', with: 'プロフィール文が変更されているはず。'
        click_button 'update_user'
        expect(user.reload.profile).to eq 'プロフィール文が変更されているはず。'
        expect(page).to have_content 'プロフィールを変更しました。'
      end

      it 'edit user_image', js: true do
        sign_in user
        find('.is-hoverable').hover
        click_link 'マイページ'
        expect(current_path).to eq user_path(user)
        click_link 'プロフィールを編集'
        expect(page).to have_button 'update_user', disabled: true
        attach_file 'user[user_image]', "#{Rails.root}/spec/fixtures/user_image_sample_after.jpg", visible: false
        click_button 'update_user'
        expect(page).to have_selector("img[src$='user_image_sample_after.jpg']")
        expect(page).to have_content 'プロフィールを変更しました。'
      end
    end
  end
end
