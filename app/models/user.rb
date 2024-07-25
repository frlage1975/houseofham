class User < ApplicationRecord
  belongs_to :role
  belongs_to :province
  has_many :reviews
  has_many :orders

  validates :name, :email, :password, :address, :phone_number, presence: true
  validates :email, uniqueness: true
end
