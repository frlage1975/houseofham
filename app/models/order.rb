class Order < ApplicationRecord
  belongs_to :user
  has_many :orders_products, dependent: :destroy
  has_many :products, through: :orders_products

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gst", "gst_rate", "hst", "hst_rate", "id", "id_value", "pst", "pst_rate", "status", "total_price", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["orders_products", "products", "user"]
  end

  validates :total_price, :status, :pst, :gst, :hst, :pst_rate, :gst_rate, :hst_rate, presence: true
  validates :total_price, :pst, :gst, :hst, :pst_rate, :gst_rate, :hst_rate, numericality:  {greater_than_or_equal_to: 0}
  validates :status, inclusion: { in: %w[new paid shipped] }
end
