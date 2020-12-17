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
<<<<<<< Updated upstream
  
=======

  put 'users/follow/:user_id' => 'users#follow'
  put 'users/unfollow/:user_id' => 'users#unfollow'

  
  get 'users/follow_list/:user_id' => 'users#follow_list'
  get 'users/follower_list/:user_id' => 'users#follower_list'

>>>>>>> Stashed changes
end
