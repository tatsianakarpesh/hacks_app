Rails.application.routes.draw do
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

  # Root route
  root to: "cars#index"
  resource :cart, only: [:show] do
    delete 'clear', to: 'carts#clear_all', as: :clear
    post 'restore', to: 'carts#restore', as: :restore
  end
  resources :cart_items, only: [:create, :destroy]
  resources :cars
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
