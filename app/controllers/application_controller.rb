class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username nickname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def user_not_authorized
    flash[:alert] = '権限がありません。'
    redirect_to(request.referer || root_path)
  end
end
