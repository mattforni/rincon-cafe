class Auth::ConfirmationsController < Devise::ConfirmationsController
  layout 'auth'

  def new
    @title = 'Email Confirmation'

    respond_to do |format|
      format.html { super }
    end
  end
end

