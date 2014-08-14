FeriaDeStartups::Application.routes.draw do

  resources :users, only: [:edit, :update]
  resources :products do
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
  
  root 'products#index'
  
  delete '/signout', to: 'sessions#destroy', via: :delete
  
end
