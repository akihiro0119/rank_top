class Like < ActiveRecord::Base
  belongs_to :post, counter_cache: :likes_count
  belongs_to :user
end
