class Province < ApplicationRecord
  has_many :users
  has_many :taxes

  validates :name, presence: true
end
