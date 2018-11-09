class Rental < ApplicationRecord
    # relationships
  belongs_to :customer
  belongs_to :movie

  # validations
  validates :checkout_date, presence: true
  validates :due_date, presence: true

  # custom model methods
  def complete?
    return !self.checkin_date.nil?
  end

  def checkout_data
    if valid_movie? && valid_cust? && movie_available?
      self.checkout_date = Date.current
      self.due_date = Date.current + 7
      self.checkin_date = nil
      # self.save
      return self
    end
    return self
  end

  def checkin_data
    if valid_movie? && valid_cust?
      movie_id = self[:movie_id]
      rented = Movie.find_by(id: movie_id)
      rented.inventory_available += 1
      rented.save
      self.checkin_date = Date.current
      return self
    end
    return self

  end

  private

  def valid_cust?
    cust_id = self[:customer_id]
    cust = Customer.find_by(id: cust_id)
    if cust.nil?
      errors.add(:customer, "customer id not in database")
      return false
    end
    return true
  end

  def valid_movie?
    movie_id = self[:movie_id]
    rentable = Movie.find_by(id: movie_id)
    if rentable.nil?
      errors.add(:movie, "movie id not in database")
      return false
    end
    return true
  end

  def movie_available?
    movie_id = self[:movie_id]
    rentable = Movie.find_by(id: movie_id)
    if rentable.inventory_available > 0
      rentable.inventory_available -= 1
      rentable.save
    else
      errors.add(:movie, "all copies are currently checked out")
      return false
    end
    return true
  end
end
