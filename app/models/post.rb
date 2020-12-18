class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user

  has_many :likes, dependent: :destroy
  
  def like_user(user_id)
    likes.find_by(user_id: user_id)
  end
  has_many :comments, dependent: :destroy

  has_many  :post_tag_relations, dependent: :destroy
  has_many  :tags, through: :post_tag_relations

  with_options presence: true do
    validates :title, length: { maximum: 40 }
    validates :rank1, length: { maximum: 40 }
    validates :rank2, length: { maximum: 40 }
    validates :rank3, length: { maximum: 40 }
  end

  def self.search(search)
    if search != ''
      Post.where('title LIKE(?)', "%#{search}%")
    else
      Post.all
    end
  end

  def liked_by?(current_user)
       likes.where(user_id: current_user.id).exists?
  end

end
