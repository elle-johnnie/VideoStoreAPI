class Customer < ApplicationRecord
  # relationships
  has_many :rentals, dependent: :nullify
  has_many :movies, :through => :rentals

  # validations
  validates :name, presence: true
  validates :registered_at, presence: true
  validates :postal_code, presence: true
  validates :phone, presence: true

end
