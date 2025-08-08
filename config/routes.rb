Rails.application.routes.draw do
  get "carts/show"
  devise_for :users
  root 'home#index'
  
  # Public routes
  resources :categories, only: [:index, :show]
  resources :products, only: [:index, :show]
  resource :cart, only: [:show, :update]
  resources :orders, only: [:index, :show, :create]
  
  # Static pages
  get 'faq', to: 'pages#faq'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  
  # Search functionality
  get 'search', to: 'products#search'
  
  # Admin routes
  namespace :admin do
    root 'dashboard#index'
    resources :products
    resources :categories
    resources :pages
    resources :orders, only: [:index, :show, :update]
    resources :users, only: [:index, :show, :edit, :update, :destroy]
  end
  
  # API routes for AJAX calls
  namespace :api do
    resources :cart_items, only: [:create, :update, :destroy]
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
