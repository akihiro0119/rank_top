Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'
  
  resources :users, only: :show

  resources :posts do
    resources :comments, only: :create
    resource :likes, only: [:create, :destroy]
    collection do
      get 'search'
    end
  end

end
