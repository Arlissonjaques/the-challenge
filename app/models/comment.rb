class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :name, :comment, presence: true
end
