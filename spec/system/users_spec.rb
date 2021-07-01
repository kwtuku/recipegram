require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'sign up' do
    let(:alice) { build :user }

    it 'valid sign up', js: true do
      visit root_path
      click_link '新規登録'
      expect(current_path).to eq new_user_registration_path
      expect(page).to have_button 'signup', disabled: true
      fill_in 'user[username]', with: alice.username
      fill_in 'user[email]', with: alice.email
      fill_in 'user[password]', with: alice.password
      fill_in 'user[password_confirmation]', with: alice.password_confirmation
      expect{ click_button 'signup' }.to change { User.count }.by(1)
      expect(page).to have_content 'アカウント登録が完了しました。'
    end
  end

  describe 'sign in' do
    let(:alice) { create :user }

    it 'valid sign in', js: true do
      visit root_path
      within '.container' do
        click_link 'ログイン'
      end
      expect(current_path).to eq new_user_session_path
      expect(page).to have_button 'signin', disabled: true
      fill_in 'user[email]', with: alice.email
      fill_in 'user[password]', with: alice.password
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
    let(:alice) { create :user, email: 'before@example.com' }

    it 'edit email', js: true do
      sign_in alice
      find('.is-hoverable').hover
      click_link 'アカウント編集'
      expect(current_path).to eq edit_user_registration_path
      expect(page).to have_button 'update_account', disabled: true
      fill_in 'user[email]', with: 'after@example.com'
      fill_in 'user[current_password]', with: alice.password
      click_button 'update_account'
      expect(alice.reload.email).to eq 'after@example.com'
      expect(page).to have_content 'アカウント情報を変更しました。'
    end
  end

  describe 'edit user' do
    context 'signed in as wrong user' do
      let(:alice) { create :user, username: 'alice' }
      let(:bob) { create :user, username: 'bob' }

      it 'can not edit', js: true do
        sign_in bob
        visit edit_user_path(alice)
        expect(current_path).to eq user_path(alice)
        expect(page).to have_content '権限がありません。'
      end
    end

    context 'signed in as correct user' do
      let(:alice) { create :user, username: 'alice', profile: "I'm alice." }

      it 'edit username', js: true do
        sign_in alice
        find('.is-hoverable').hover
        click_link 'マイページ'
        expect(current_path).to eq user_path(alice)
        click_link 'プロフィールを編集'
        expect(page).to have_button 'update_user', disabled: true
        fill_in 'user[username]', with: 'アリス'
        click_button 'update_user'
        expect(alice.reload.username).to eq 'アリス'
        expect(page).to have_content 'プロフィールを変更しました。'
      end

      it 'edit profile', js: true do
        sign_in alice
        find('.is-hoverable').hover
        click_link 'マイページ'
        expect(current_path).to eq user_path(alice)
        click_link 'プロフィールを編集'
        expect(page).to have_button 'update_user', disabled: true
        fill_in 'user[profile]', with: 'アリスです。'
        click_button 'update_user'
        expect(alice.reload.profile).to eq 'アリスです。'
        expect(page).to have_content 'プロフィールを変更しました。'
      end

      it 'edit user_image', js: true do
        sign_in alice
        before_image_public_id = alice.user_image.public_id
        find('.is-hoverable').hover
        click_link 'マイページ'
        expect(current_path).to eq user_path(alice)
        click_link 'プロフィールを編集'
        expect(page).to have_button 'update_user', disabled: true
        attach_file 'user[user_image]', "#{Rails.root}/spec/fixtures/user_image_sample_after.jpg", visible: false
        click_button 'update_user'
        after_image_public_id = alice.reload.user_image.public_id
        expect(before_image_public_id).to_not eq after_image_public_id
        expect(page).to have_content 'プロフィールを変更しました。'
      end
    end
  end
end
