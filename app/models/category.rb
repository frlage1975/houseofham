class Category < ApplicationRecord
  has_many :products

  validates :name, :description, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "name", "updated_at"]
  end
end
