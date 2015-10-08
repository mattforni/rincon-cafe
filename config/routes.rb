Rails.application.routes.draw do
  devise_for :users

  root 'application#splash'
  resources :orders, except: [:edit, :index, :new]
end

