Rails.application.routes.draw do
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
