class OrdersProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, :price, presence: true
  validates :quantity, :price, numericality: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "order_id", "price", "product_id", "quantity", "tax_id", "updated_at"]
  end
end
