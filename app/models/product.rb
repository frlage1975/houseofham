class Product < ApplicationRecord
  belongs_to :category
  has_many :reviews
  has_many :orders_products
  has_many :orders, through: :orders_products

  has_one_attached :image

  validates :name, :description, :base_price, :stock_quantity, :category_id, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["category", "image_attachment", "image_blob", "orders", "orders_products", "reviews"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["base_price", "category_id", "created_at", "description", "id", "id_value", "name", "stock_quantity", "updated_at"]
  end
end
