Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :users
  resources :roles
  resources :reviews
  resources :products, only: [:index, :show]
  resources :categories
  resources :provinces
  resources :orders
  resources :orders_products
  resources :taxes

  root 'products#index'
end
