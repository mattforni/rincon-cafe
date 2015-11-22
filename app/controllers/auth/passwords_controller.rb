class Auth::PasswordsController < Devise::PasswordsController
  layout 'auth'

  def edit
    @title = 'Set Password'

    respond_to do |format|
      format.html { super }
    end
  end

  def new
    @title = 'Reset Password'

    respond_to do |format|
      format.html { super }
    end
  end

  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    root_path
  end
end

