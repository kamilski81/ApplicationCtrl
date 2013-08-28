class User::ParameterSanitizer < Devise::ParameterSanitizer

  private

  def account_update
    default_params.permit(:email, :password, :password_confirmation, :current_password, :group_ids => [])
  end

end