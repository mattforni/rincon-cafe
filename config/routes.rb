Rails.application.routes.draw do
  root 'application#splash'

  devise_for :users, controllers: {sessions: 'auth/sessions', registrations: 'auth/registrations'}

  get 'orders/last', to: 'orders#last', as: 'orders_last'
  resources :orders, except: [:edit, :index, :new]
end

