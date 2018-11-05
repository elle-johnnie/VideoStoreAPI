class Rental < ApplicationRecord
  # relationships
  belongs_to :customer
  belongs_to :movie

  # validations
  validates :checkout_date, presence: true
  validates :due_date, presence: true


end
