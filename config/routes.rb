Rails.application.routes.draw do
  root 'lists#index'

  resources :lists do
    member do
      post :soft_delete
      post :restore
    end
    resources :items, except: [:index] do
      member do
        post :soft_delete
        post :restore
      end
    end
  end

  get '/trash' => 'pages#trash'
end
