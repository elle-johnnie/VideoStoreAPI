class Rental < ApplicationRecord
    # relationships
  belongs_to :customer #, counter_cache: :movies_out_count
  belongs_to :movie

  # validationss
  validates :checkout_date, presence: true
  validates :due_date, presence: true

  # custom model methods
  def complete?
    return !self.checkin_date.nil?
  end

end

# Rental.new(checkout_date: Date.yesterday, due_date: Date.tomorrow, movie_id: 4, customer_id: 1)
