class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy

  acts_as_followable
  acts_as_follower

  
  has_one_attached :image
  mount_uploader :image, ImageUploader

  with_options presence: true do
    validates :name, length: { maximum: 20 }
    validates :profile, length: { maximum: 300 }
  end

  half_width_alphanumeric = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{6,100}+\z/i
  validates :password, presence: true, on: :create, format: { with: half_width_alphanumeric, message: 'に半角英数字を使用してください' }


  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
end
