Rails.application.routes.draw do
  # Root route must be at the top
  root "cars#index"

  # Authentication routes
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  # Profile routes
  devise_scope :user do
    get 'profile', to: 'users/registrations#show', as: :user_profile
    get 'profile/password/edit', to: 'users/passwords#edit', as: :edit_profile_password
    put 'profile/password', to: 'users/passwords#update', as: :update_profile_password
  end

  # Resource routes
  resources :cars
  resources :cart_items, only: [:create, :destroy]

  # Cart routes
  resource :cart, only: [:show] do
    delete 'clear', to: 'carts#clear_all', as: :clear
    post 'restore', to: 'carts#restore', as: :restore
  end

  # Checkout routes
  get 'checkout', to: 'checkout#index', as: :checkout
  post 'checkout/process', to: 'checkout#process_order', as: :process_checkout
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
