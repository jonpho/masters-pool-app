Rails.application.routes.draw do
  resources :golfers
  post 'leaderboards/single_entry', to: 'leaderboards#single_entry'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
