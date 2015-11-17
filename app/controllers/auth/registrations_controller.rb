class Auth::RegistrationsController < Devise::RegistrationsController
  layout 'auth'

  def show
    @user = User.find(params[:id])
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

