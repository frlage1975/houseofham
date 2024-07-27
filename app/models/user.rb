class User < ApplicationRecord
  # has_secure_password

  belongs_to :role
  belongs_to :province
  has_many :reviews
  has_many :orders

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :address, presence: true
  validates :province_id, presence: true
  validates :password, presence: true, length: { minimum: 6 }
end
