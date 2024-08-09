class Tax < ApplicationRecord
  belongs_to :province
  has_many :orders_products

  def self.ransackable_associations(auth_object = nil)
    ["orders_products", "province"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gst_rate", "hst_rate", "id", "id_value", "province_id", "pst_rate", "updated_at"]
  end

  validates :gst_rate, :pst_rate, :hst_rate, presence: true
  validates :gst_rate, :pst_rate, :hst_rate, numericality: true
end
