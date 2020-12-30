class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    @posts = params[:tag_id].present? ? Tag.find(params[:tag_id]).posts : Post.includes(:user).order('created_at DESC')
    @likes = Like.where(user_id: current_user)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.likes_count = (0)
    if @post.valid?
      @post.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user)
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
    redirect_to root_path
  end

  def search
    @posts = Post.search(params[:keyword])
  end

  private

  def post_params
    params.require(:post).permit(:title, :rank1, :rank2, :rank3, :image, :likes_count,
                                 tag_ids: []).merge(user_id: current_user.id)
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end
end
