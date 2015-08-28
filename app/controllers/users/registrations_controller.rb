class Users::RegistrationsController < Devise::RegistrationsController

  def sign_up_params
    params.require(:user).permit(:name, :title, :email, :password, :password_confirmation)
  end

end
