Rails.application.routes.draw do
  root 'queue#index'

  devise_for :users, controllers: {sessions: 'auth/sessions', registrations: 'auth/registrations'}

  get 'orders/last', to: 'orders#last', as: 'orders_last'
  resources :orders, except: :new
end

