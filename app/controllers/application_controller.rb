class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
    def after_sign_in_path_for(resource)
      root_path
    end

    def after_sign_up_path_for(resource)
      root_path
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :nickname])
    end
end
