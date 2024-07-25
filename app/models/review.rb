class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :rating, :comment, presence: true
end
