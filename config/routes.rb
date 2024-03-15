Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'common_ancestors', to: 'common_ancestors#index'

  get 'birds', to: 'birds#index'
end
