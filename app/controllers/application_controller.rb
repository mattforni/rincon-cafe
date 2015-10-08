class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery

  def splash
  end
end
