Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :golfers
  post 'leaderboards/single_entry', to: 'leaderboards#single_entry'
  post 'golfers/create', to: 'golfers#create'
  get 'leaderboards', to: 'leaderboards#index'
  get 'flights', to: 'flights#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
