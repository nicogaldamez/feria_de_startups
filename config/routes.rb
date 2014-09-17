FeriaDeStartups::Application.routes.draw do

  resources :users
  resources :products do
    member do
      get 'view'
    end
    resources :votes, only: [] do
      collection do
        get 'vote'
      end
    end
  end
  
  get '/auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/'), via: [:get, :post]

  # Admin
  get '/admin/send_daily'
  get '/admin/send_voted_products'
  resources :admin, only: [:index] do
    member do
      put 'toggle_published'
    end
    collection do
      get 'products'
    end
  end
  resources :categories
  
  root 'products#index'
  
  delete '/signout', to: 'sessions#destroy', via: :delete
  
end
