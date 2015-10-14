class Auth::RegistrationsController < Devise::RegistrationsController
  layout 'auth'

  def show
    @user = User.find(params[:id])
  end
end

