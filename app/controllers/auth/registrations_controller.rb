class Auth::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def show
    @user = User.find(params[:id])
  end
end

