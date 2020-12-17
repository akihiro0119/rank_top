class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

    acts_as_followable # フォロワー機能
    acts_as_follower   # フォロー機能

  has_one_attached :avatar

  with_options presence: true do


    validates :name, length: { maximum: 20 }
    validates :profile, length: { maximum: 300 }
    
    PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
    validates_format_of :password, with: PASSWORD_REGEX, message: 'is invalid. Input full-width characters.'



    validates :name, length: { maximum: 20 }
    validates :profile, length: { maximum: 300 }

    PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
    validates_format_of :password, with: PASSWORD_REGEX, message: 'is invalid. Input full-width characters.'



  end


  

end
