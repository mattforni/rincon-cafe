class Auth::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_filter :authenticate_user!, only: [:create, :new]
  skip_authorization_check only: [:create, :failure, :show_current_user, :options, :new]

  def create
    # Send HTML handling to the default Devise controller
    respond_to do |format|
      format.html { super }
      format.json {
        puts params.inspect
        resource = resource_class.find_for_database_authentication({ email: params[:email] })
        if resource.nil? or !resource.valid_password?(params[:password])
          warden.custom_failure!
          render json: { message: 'Invalid credentials' }, status: 401 and return
        end

        render json: resource.as_json, success: true, status: :created
      }
    end
  end

  def new
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

