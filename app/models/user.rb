class User < ApplicationRecord
  has_secure_password

  belongs_to :role
  belongs_to :province
  has_many :reviews
  has_many :orders

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :address, presence: true
  validates :province_id, presence: true
  validates :password, presence: true, length: { minimum: 6 }

  before_create :set_default_role

  def self.ransackable_associations(auth_object = nil)
    ["orders", "province", "reviews", "role"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["address", "created_at", "email", "encrypted_password", "id", "id_value", "name", "password", "password_digest", "phone_number", "province_id", "remember_created_at", "reset_password_sent_at", "reset_password_token", "role_id", "updated_at"]
  end

  private

  def set_default_role
    self.role_id ||= 1
  end
end
