class Province < ApplicationRecord
  has_many :users
  has_many :taxes

  validates :name, presence: true, uniqueness: true
  validates :name, length: { minimum: 2, maximum: 100 }
  validates :name, format: { with: /\A[a-zA-Z\s]+\z/, message: "only allows letters and spaces" }
end
