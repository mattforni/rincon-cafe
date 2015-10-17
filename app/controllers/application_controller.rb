require 'cafe'

class ApplicationController < ActionController::Base
  before_action :authenticate_via_token!
  before_action :authenticate_user!

  protect_from_forgery with: :null_session

  protected

  def authenticate_via_token!
    email = request.headers["X-API-EMAIL"].presence
    token = request.headers["X-API-TOKEN"].presence

    user = email && User.where({email: email}).first
    sign_in(user, store: false) if user && user.token_valid?(token)
  end

  # TODO test
  def closed?
    return if Cafe.open? or current_user.admin # If the cafe is currently open, do nothing

    respond_to do |format|
      format.html {
        redirect_to cafe_closed_path
      }
      format.json {
        # If the cafe is not currently open inform the user with a locked status code
        render json: { message: 'Cafe is closed' }, success: false, status: :locked
      }
    end
  end

  def json_unsupported
    render json: { error: 'JSON not supported' }, success: false, status: :not_found
  end
end

