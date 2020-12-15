class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_search

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :profile, :profile_image])
  end

  def set_search
    @search = Post.ransack(params[:q])
    @posts = @search.result
  end

end
