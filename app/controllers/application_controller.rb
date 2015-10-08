class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery

  def splash
  end

  protected

  def json_only
    raise ArgumentError.new('Block must be provided') if !block_given?
    respond_to do |format|
      format.json { yield }
      format.all { head 400 }
    end
  end
end
