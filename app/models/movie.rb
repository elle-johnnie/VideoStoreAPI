class Movie < ApplicationRecord
  # relationships
  has_many :rentals
  has_many :customers, :through => :rentals

  # validations
  validates :overview, presence: true
  validates :title, presence: true
  validates :release_date, presence: true
  validates :inventory, presence: true
  validates :inventory_availability, presence: true

end
