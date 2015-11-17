Rails.application.routes.draw do
  root 'cafe#queue'
  get 'closed', to: 'cafe#closed', as: 'cafe_closed'

  devise_for :users, controllers: {sessions: 'auth/sessions', registrations: 'auth/registrations'}
  devise_scope :user do
    get 'users/:id', to: 'auth/registrations#show', as: 'user'
  end

  # TODO add me back in!!
  # resources :orders, only: [:create, :destroy, :index, :new]
  resources :orders, only: [:create, :destroy, :index]
  get 'orders/last', to: 'orders#last', as: 'orders_last'
end

