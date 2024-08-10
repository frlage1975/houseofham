class Role < ApplicationRecord
  has_many :users

  validates :role_name, presence: true, uniqueness: true
  validates :role_name, length: { minimum: 3, maximum: 50 }
end
