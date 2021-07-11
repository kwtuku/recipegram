module SignOutModule
  def sign_out(user)
    visit root_path
    find('.is-hoverable').hover
    click_link 'ログアウト'
  end
end
