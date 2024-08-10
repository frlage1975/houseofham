class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :rating, :comment, presence: true
  validates :rating, presence: true, numericality: {only_integer: true, greater_than: 0, less_than_or_equal_to: 5}

  def self.ransackable_attributes(auth_object = nil)
    ["comment", "created_at", "id", "id_value", "product_id", "rating", "updated_at", "user_id"]
  end
end
