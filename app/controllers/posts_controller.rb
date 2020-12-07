class PostsController < ApplicationController

  def index
    @posts = Post.includes(:user).order("created_at DESC")
  end

  def new
    @post = Post.new
  end

  def create
    Post.create(post_params)
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
      if @post.update(post_params)
        redirect_to root_path
      else
        render :edit
      end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
  end

private

  def post_params
    params.require(:post).permit(:title, :rank1, :rank2, :rank3, :image).merge(user_id: current_user.id)
  end
end
