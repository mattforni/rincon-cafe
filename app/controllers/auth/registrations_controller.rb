class Auth::RegistrationsController < Devise::RegistrationsController
  respond_to :json, :html
end

