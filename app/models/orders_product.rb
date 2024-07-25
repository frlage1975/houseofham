class OrdersProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :tax
end
