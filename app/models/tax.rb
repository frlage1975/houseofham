class Tax < ApplicationRecord
  belongs_to :province
  has_many :orders_products

  validates :gst_rate, :pst_rate, :hst_rate, presence: true
end
