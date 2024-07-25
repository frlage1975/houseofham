class Product < ApplicationRecord
  belongs_to :category
  has_many :reviews
  has_many :orders_products
  has_many :orders, through: :orders_products

  validates :name, :description, :base_price, :stock_quantity, :category_id, presence: true
end
