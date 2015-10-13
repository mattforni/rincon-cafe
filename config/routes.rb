Rails.application.routes.draw do
  root 'cafe#queue'
  get 'closed', to: 'cafe#closed', as: 'cafe_closed'

  devise_for :users, controllers: {sessions: 'auth/sessions', registrations: 'auth/registrations'}
  devise_scope :user do
    get 'users/:id', to: 'auth/registrations#show', as: 'user'
  end

  get 'orders/last', to: 'orders#last', as: 'orders_last'
  resources :orders, except: :new
end

