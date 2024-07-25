Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :users
  resources :roles
  resources :reviews
  resources :products
  resources :categories
  resources :provinces
  resources :orders
  resources :orders_products
  resources :taxes
end
