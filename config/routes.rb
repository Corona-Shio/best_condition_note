Rails.application.routes.draw do
  root   "static_pages#home"
  get    "/help",    to: "static_pages#help"
  get    "/about",   to: "static_pages#about"
  get    "/contact", to: "static_pages#contact"
  get    "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  # get "/users/:id/new",   to: "daily_records#new"
  # get "/users/:id/graph", to: "daily_records#show"
  resources :users
  resources :daily_records do
    collection do
      get 'graph'  # /daily_records/graph にマッピング
    end
  end
  # resources :daily_records, path: 'condition'
  # resources :users do
  #   member do
  #     resources :daily_records
  #   end
  # end 
end
