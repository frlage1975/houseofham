Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'

  post 'checkout', to: 'checkout#create', as: 'checkout'
  get 'invoice', to: 'checkout#show', as: 'invoice'

  get 'checkout/create'
  get 'static_pages/show'

  get 'check_ins/new'
  get 'check_ins/create'

  post 'checkout/buy_later', to: 'checkout#buy_later', as: 'buy_later_checkout'
  get 'checkout/pay_now/:id', to: 'checkout#pay_now', as: 'pay_now_checkout'
  post 'checkout/create_payment', to: 'checkout#create_payment', as: 'create_payment'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :products, only: [:index, :show]
  resources :users, only: [:new, :create]
  resource  :session, only: [:new, :create, :destroy]
  resources :categories, only: [:show]
  # resources :orders, only: [:index, :show]
  resources :orders do
    member do
      post 'pay', to: 'checkout#pay'
      #get 'pay_now', to: 'checkout#pay_now'
      #post 'create_payment', to: 'checkout#create_payment'
    end
  end
  resources :roles
  resources :reviews
  resources :categories
  resources :provinces
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

  # Custom route for marking orders as shipped
  namespace :admin do
    resources :orders do
      member do
        put :mark_as_shipped
      end
    end
  end
end
