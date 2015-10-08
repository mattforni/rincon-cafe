Rails.application.routes.draw do
  root 'application#splash'

  devise_for :users, controllers: {sessions: 'auth/sessions', registrations: 'auth/registrations'}

  resources :orders, except: [:edit, :index, :new]
end

