class Order < ApplicationRecord
  belongs_to :user
  has_many :orders_products, dependent: :destroy
  has_many :products, through: :orders_products

  validates :total_price, :status, :pst, :gst, :hst, :pst_rate, :gst_rate, :hst_rate, presence: true
end
