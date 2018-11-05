class Customer < ApplicationRecord
  # relationships
  has_many :rentals
  has_many :movies, :through => :rentals

  # validations



end
