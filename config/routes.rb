Rails.application.routes.draw do
  root   "static_pages#home"
  get    "/help",    to: "static_pages#help"
  get    "/about",   to: "static_pages#about"
  get    "/contact", to: "static_pages#contact"
  get    "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"

  resources :users
  resources :daily_records do
    collection do
      get "graph"
      get "empty"
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: %i[new create edit update]
  resources :password_changes,    only: %i[edit update]
  
end
