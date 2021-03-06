class Auth::SessionsController < Devise::SessionsController
  layout 'auth'
  skip_before_filter :authenticate_user!, only: [:create, :new]
  skip_authorization_check only: [:create, :failure, :show_current_user, :options, :new]

  def create
    # Send HTML handling to the default Devise controller
    respond_to do |format|
      format.html { super }
      format.json {
        user = User.where({ email: params[:user][:email] }).first
        if user.nil? or !user.valid_password?(params[:user][:password])
          warden.custom_failure!
          render json: { message: 'Invalid credentials' }, status: 401 and return
        end

        render json: user.as_json, success: true, status: :created
      }
    end
  end

  def new
    @title = 'Rincon Cafe'

    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords resource
    respond_with resource, serialize_options(resource)
  end

  def destroy
    respond_to do |format|
      # Send HTML handling to the default Devise controller
      format.html { super }
      format.json {
        user = User.where({ token: request.headers['X-API-TOKEN'] }).first
        render json: { message: 'Invalid token' }, status: 404 and return if user.nil?

        user.reset_token!
        render json: { message: 'Session deleted' }, status: 204, success: true
      }
    end
  end
end

