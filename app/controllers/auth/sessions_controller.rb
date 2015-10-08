class Auth::SessionsController < Devise::SessionsController
  respond_to :json
end

