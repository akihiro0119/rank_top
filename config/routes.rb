Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'
  
  resources :users, only: :show

  resources :posts do
    resource :likes, only: [:create, :destroy]
  end

end
