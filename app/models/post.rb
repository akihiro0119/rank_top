class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user

  has_many :likes, dependent: :destroy
  def like_user(user_id)
    likes.find_by(user_id: user_id)
  end
  has_many :comments

  has_many  :post_tag_relations, dependent: :destroy
  has_many  :tags, through: :post_tag_relations



validates :title, presence: true
validates :rank1, presence: true
validates :rank2, presence: true
validates :rank3, presence: true



  def self.search(search)
    if search != ""
      Post.where('title LIKE(?)', "%#{search}%")
    else
      Post.all
    end
  end

  def save_tags(savepost_tags)
    savepost_tags.each do |new_name|
    post_tag = Tag.find_or_create_by(tag_name: new_name)
    self.tags << post_tag
    end
  end


end
