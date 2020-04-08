class Relationship < ApplicationRecord
  belongs_to :user
  # followモデルなんて存在しないので、userモデルにbelongs_toしてね！
  belongs_to :follow, class_name: 'User'

  validates :user_id, presence: true
  validates :follow_id, presence: true
end
