module Users
  class RegistrationsController < Devise::RegistrationsController
    prepend_before_action :authenticate_scope!, only: %i[edit update confirm_destroy destroy] # rubocop:disable Rails/LexicallyScopedActionFilter

    def confirm_destroy; end

    # rubocop:disable Metrics/AbcSize
    def destroy
      if resource.destroy_with_password(destroy_params[:current_password])
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        set_flash_message :notice, :destroyed
        yield resource if block_given?
        respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
      else
        render 'confirm_destroy'
      end
    end
    # rubocop:enable Metrics/AbcSize

    private

    def destroy_params
      params.require(:user).permit(:current_password)
    end
  end
end
