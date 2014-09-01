FeriaDeStartups::Application.routes.draw do

  resources :users, only: [:edit, :update]
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
  get '/admin', to: 'admin#index'
  
  root 'products#index'
  
  delete '/signout', to: 'sessions#destroy', via: :delete
  
end
