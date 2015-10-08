class ApplicationController < ActionController::Base
  before_action :authenticate_via_token!
  before_action :authenticate_user!

  protect_from_forgery with: :null_session

  def splash
  end

  protected

  def authenticate_via_token!
    email = request.headers["X-API-EMAIL"].presence
    token = request.headers["X-API-TOKEN"].presence

    user = email && User.where({email: email}).first
    sign_in(user, store: false) if user && user.token_valid?(token)
  end
end

