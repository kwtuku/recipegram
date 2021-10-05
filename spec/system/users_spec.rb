require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:ellen) { create :user, :no_image }

  describe 'signs up' do
    let(:alice) { build :user, :no_image }

    it 'signs up', js: true do
      visit root_path
      click_link '登録'
      expect(page).to have_button 'signup', disabled: true
      fill_in 'user[username]', with: alice.username
      fill_in 'user[nickname]', with: alice.nickname
      fill_in 'user[email]', with: alice.email
      fill_in 'user[password]', with: alice.password
      fill_in 'user[password_confirmation]', with: alice.password_confirmation
      expect { click_button 'signup' }.to change(User, :count).by(1)
      expect(page).to have_content 'アカウント登録が完了しました。'
    end

    it 'generates valid username', js: true do
      visit root_path
      click_link '登録'
      expect(page).to have_field 'user[username]', with: ''
      click_link href: generate_username_path
      expect(page).to have_selector '.rspec_has_generated_username'
      valid_username_regex = /\A[a-zA-Z0-9_-]+\z/
      expect(page).to have_field 'user[username]', with: valid_username_regex
      generated_username = find_field('user[username]').value
      expect(generated_username).not_to eq ''
      expect(User.exists?(username: generated_username)).to eq false
    end
  end

  describe 'signs in' do
    let(:alice) { create :user, :no_image }

    it 'signs in', js: true do
      visit root_path
      click_link 'ログイン'
      expect(page).to have_button 'signin', disabled: true
      fill_in 'user[email]', with: alice.email
      fill_in 'user[password]', with: alice.password
      click_button 'signin'
      expect(page).to have_content 'ログインしました。'
    end

    it 'signs in as guest' do
      visit root_path
      click_link 'ゲストログイン'
      expect(page).to have_content 'ゲストユーザーとしてログインしました。'
    end
  end

  describe 'updates account' do
    let(:bob) { create :user, :no_image, username: 'before', email: 'before@example.com' }

    it 'updates username', js: true do
      sign_in bob
      find('.rspec_header_dropdown_trigger').click
      click_link 'アカウント編集'
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
      expect(page).to have_button 'update_account', disabled: true
      fill_in 'user[email]', with: 'after@example.com'
      fill_in 'user[current_password]', with: bob.password
      click_button 'update_account'
      expect(bob.reload.email).to eq 'after@example.com'
      expect(page).to have_content 'アカウント情報を変更しました。'
    end

    describe 'updates password' do
      let(:bob) { create :user, :no_image, password: 'old_password', password_confirmation: 'old_password' }

      before do
        sign_in bob
        find('.rspec_header_dropdown_trigger').click
        click_link 'アカウント編集'
      end

      it 'signs in with new password after a password updated', js: true do
        expect(page).to have_button 'update_account', disabled: true
        fill_in 'user[password]', with: 'new_password'
        fill_in 'user[password_confirmation]', with: 'new_password'
        fill_in 'user[current_password]', with: bob.password
        click_button 'update_account'
        expect(page).to have_content 'アカウント情報を変更しました。'
        sign_out
        visit root_path
        click_link 'ログイン'
        fill_in 'user[email]', with: bob.email
        fill_in 'user[password]', with: 'new_password'
        click_button 'signin'
        expect(page).to have_content 'ログインしました。'
      end

      it 'does not sign in with old password after a password updated', js: true do
        expect(page).to have_button 'update_account', disabled: true
        fill_in 'user[password]', with: 'new_password'
        fill_in 'user[password_confirmation]', with: 'new_password'
        fill_in 'user[current_password]', with: bob.password
        click_button 'update_account'
        expect(page).to have_content 'アカウント情報を変更しました。'
        sign_out
        visit root_path
        click_link 'ログイン'
        fill_in 'user[email]', with: bob.email
        fill_in 'user[password]', with: 'old_password'
        click_button 'signin'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end
  end

  describe 'updates user' do
    let(:carol) { create :user, :no_image, nickname: 'carol', profile: 'I am carol.' }
    let(:dave) { create :user }

    it 'updates nickname', js: true do
      sign_in carol
      find('.rspec_header_dropdown_trigger').click
      click_link 'マイページ'
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
      click_link 'プロフィールを編集'
      expect(page).to have_button 'update_user', disabled: true
      fill_in 'user[profile]', with: 'キャロルです。'
      click_button 'update_user'
      expect(carol.reload.profile).to eq 'キャロルです。'
      expect(page).to have_content 'プロフィールを変更しました。'
    end

    it 'updates user_image', js: true do
      sign_in dave
      before_image_url = dave.user_image.url
      find('.rspec_header_dropdown_trigger').click
      click_link 'マイページ'
      click_link 'プロフィールを編集'
      expect(page).to have_button 'update_user', disabled: true
      attach_file 'user[user_image]', Rails.root.join('spec/fixtures/user_image_sample_after.jpg'), visible: false
      click_button 'update_user'
      after_image_url = dave.reload.user_image.url
      expect(before_image_url).not_to eq after_image_url
      expect(page).to have_content 'プロフィールを変更しました。'
    end
  end

  it 'destroys account', js: true do
    sign_in ellen
    find('.rspec_header_dropdown_trigger').click
    click_link 'アカウント削除手続き'
    expect(page).to have_button 'destroy_account', disabled: true
    fill_in 'user[current_password]', with: ellen.password
    expect  do
      click_button 'destroy_account'
    end.to change(User, :count).by(-1)
    expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
  end
end
