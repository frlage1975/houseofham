Rails.application.routes.draw do
  get 'static_pages/show'

  get 'check_ins/new'
  get 'check_ins/create'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :products, only: [:index, :show]
  resources :users, only: [:new, :create]
  resource  :session, only: [:new, :create, :destroy]
  resources :categories, only: [:show]
  resources :roles
  resources :reviews
  resources :categories
  resources :provinces
  resources :orders
  resources :orders_products
  resources :taxes

  post 'shopping_cart/add', to: 'shopping_cart#add', as: 'add_to_cart'
  delete 'shopping_cart/remove', to: 'shopping_cart#remove', as: 'remove_from_cart'
  post 'shopping_cart/update', to: 'shopping_cart#update', as: 'update_cart'
  get 'shopping_cart/show', to: 'shopping_cart#show', as: 'shopping_cart_show'

  get 'check_in', to: 'check_ins#new'
  post 'check_in', to: 'check_ins#create'

  get 'about', to: 'static_pages#show', defaults: { id: 'about' }
  get 'contact', to: 'static_pages#show', defaults: { id: 'contact' }

  root 'products#index'
end
