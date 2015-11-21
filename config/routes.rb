Rails.application.routes.draw do
  root 'cafe#queue'
  get 'closed', to: 'cafe#closed', as: 'cafe_closed'

  devise_for :users, controllers: {
    confirmations: 'auth/confirmations',
    registrations: 'auth/registrations',
    sessions: 'auth/sessions'
  }
  devise_scope :user do
    get 'users/:id', to: 'auth/registrations#show', as: 'user'
  end

  resources :orders, only: [:create, :index, :new, :update]
  get 'orders/last', to: 'orders#last', as: 'orders_last'
end

