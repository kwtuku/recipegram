require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'sign up' do
    let(:alice) { build :user, :no_image }

    it 'signs up', js: true do
      visit root_path
      click_link '新規登録'
      expect(current_path).to eq new_user_registration_path
      expect(page).to have_button 'signup', disabled: true
      fill_in 'user[username]', with: alice.username
      fill_in 'user[nickname]', with: alice.nickname
      fill_in 'user[email]', with: alice.email
      fill_in 'user[password]', with: alice.password
      fill_in 'user[password_confirmation]', with: alice.password_confirmation
      expect{ click_button 'signup' }.to change { User.count }.by(1)
      expect(page).to have_content 'アカウント登録が完了しました。'
    end

    it 'generates valid username', js: true do
      visit root_path
      click_link '新規登録'
      expect(page).to have_field 'user[username]', with: ''
      click_link href: generate_username_path
      expect(page).to have_selector '.rspec_has_generated_username'
      VALID_USERNAME_REGEX = /\A[a-zA-Z0-9[-][_]]+\z/
      expect(page).to have_field 'user[username]', with: VALID_USERNAME_REGEX
      GENERATED_USERNAME = find_field('user[username]').value
      expect(GENERATED_USERNAME).to_not eq ''
      expect(User.exists?(username: GENERATED_USERNAME)).to eq false
    end
  end

  describe 'signs in' do
    let(:alice) { create :user, :no_image }

    it 'signs in with valid information', js: true do
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

    it 'signs in as guest' do
      visit root_path
      click_link 'ゲストユーザーとしてログイン'
      expect(page).to have_content 'ゲストユーザーとしてログインしました。'
    end
  end

  describe 'updates account' do
    let(:bob) { create :user, :no_image, username: 'before', email: 'before@example.com' }

    it 'updates username', js: true do
      sign_in bob
      find('.rspec_header_dropdown_trigger').click
      click_link 'アカウント編集'
      expect(current_path).to eq edit_user_registration_path
      expect(page).to have_button 'update_account', disabled: true
      fill_in 'user[username]', with: 'after'
      fill_in 'user[current_password]', with: bob.password
      click_button 'update_account'
      expect(bob.reload.username).to eq 'after'
      expect(page).to have_content 'アカウント情報を変更しました。'
    end

    it 'updates email', js: true do
      sign_in bob
      find('.rspec_header_dropdown_trigger').click
      click_link 'アカウント編集'
      expect(current_path).to eq edit_user_registration_path
      expect(page).to have_button 'update_account', disabled: true
      fill_in 'user[email]', with: 'after@example.com'
      fill_in 'user[current_password]', with: bob.password
      click_button 'update_account'
      expect(bob.reload.email).to eq 'after@example.com'
      expect(page).to have_content 'アカウント情報を変更しました。'
    end

    describe 'updates password' do
      let(:bob) { create :user, :no_image, password: 'password' }

      it 'signs in with new password after a password updated', js: true do
        sign_in bob
        find('.rspec_header_dropdown_trigger').click
        click_link 'アカウント編集'
        expect(current_path).to eq edit_user_registration_path
        expect(page).to have_button 'update_account', disabled: true
        fill_in 'user[password]', with: 'newpassword'
        fill_in 'user[password_confirmation]', with: 'newpassword'
        fill_in 'user[current_password]', with: bob.password
        click_button 'update_account'
        expect(page).to have_content 'アカウント情報を変更しました。'
        sign_out bob

        visit root_path
        within '.container' do
          click_link 'ログイン'
        end
        fill_in 'user[email]', with: bob.email
        fill_in 'user[password]', with: 'newpassword'
        click_button 'signin'
        expect(page).to have_content 'ログインしました。'
      end

      it 'does not sign in with old password after a password updated', js: true do
        sign_in bob
        find('.rspec_header_dropdown_trigger').click
        click_link 'アカウント編集'
        expect(current_path).to eq edit_user_registration_path
        expect(page).to have_button 'update_account', disabled: true
        fill_in 'user[password]', with: 'newpassword'
        fill_in 'user[password_confirmation]', with: 'newpassword'
        fill_in 'user[current_password]', with: bob.password
        click_button 'update_account'
        expect(page).to have_content 'アカウント情報を変更しました。'
        sign_out bob

        visit root_path
        within '.container' do
          click_link 'ログイン'
        end
        fill_in 'user[email]', with: bob.email
        fill_in 'user[password]', with: 'password'
        click_button 'signin'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end
  end

  describe 'updates user' do
    let(:carol) { create :user, :no_image, nickname: 'carol', profile: "I'm carol." }

    it 'updates nickname', js: true do
      sign_in carol
      find('.rspec_header_dropdown_trigger').click
      click_link 'マイページ'
      expect(current_path).to eq user_path(carol)
      click_link 'プロフィールを編集'
      expect(page).to have_button 'update_user', disabled: true
      fill_in 'user[nickname]', with: 'キャロル'
      click_button 'update_user'
      expect(carol.reload.nickname).to eq 'キャロル'
      expect(page).to have_content 'プロフィールを変更しました。'
    end

    it 'updates profile', js: true do
      sign_in carol
      find('.rspec_header_dropdown_trigger').click
      click_link 'マイページ'
      expect(current_path).to eq user_path(carol)
      click_link 'プロフィールを編集'
      expect(page).to have_button 'update_user', disabled: true
      fill_in 'user[profile]', with: 'キャロルです。'
      click_button 'update_user'
      expect(carol.reload.profile).to eq 'キャロルです。'
      expect(page).to have_content 'プロフィールを変更しました。'
    end

    let(:dave) { create :user, :no_image }

    it 'updates user_image', js: true do
      sign_in dave
      before_image_url = dave.user_image.url
      find('.rspec_header_dropdown_trigger').click
      click_link 'マイページ'
      expect(current_path).to eq user_path(dave)
      click_link 'プロフィールを編集'
      expect(page).to have_button 'update_user', disabled: true
      attach_file 'user[user_image]', "#{Rails.root}/spec/fixtures/user_image_sample_after.jpg", visible: false
      click_button 'update_user'
      after_image_url = dave.reload.user_image.url
      expect(before_image_url).to_not eq after_image_url
      expect(page).to have_content 'プロフィールを変更しました。'
    end
  end

  let(:ellen) { create :user, :no_image }

  it 'destroys account', js: true do
    sign_in ellen
    find('.rspec_header_dropdown_trigger').click
    click_link 'アカウント編集'
    click_link 'アカウント削除手続きへ'
    expect(current_path).to eq users_confirm_destroy_path
    expect(page).to have_button 'destroy_account', disabled: true
    fill_in 'user[current_password]', with: ellen.password
    expect{
      click_button 'destroy_account'
    }.to change { User.count }.by(-1)
    expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
  end
end
