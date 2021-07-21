module SignOutModule
  def sign_out(user)
    visit root_path
    find('.rspec_header_dropdown_trigger').click
    click_link 'ログアウト'
  end
end
