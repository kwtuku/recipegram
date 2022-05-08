module Users
  class SessionsController < Devise::SessionsController
    def guest_sign_in
      user = User.guest
      sign_in user
      redirect_to after_sign_in_path_for(user), notice: 'ゲストユーザーとしてログインしました。'
    end
  end
end
