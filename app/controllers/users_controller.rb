class UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    @name = user.name
    @posts = user.posts.includes(:user).order("created_at DESC")
  end
end
