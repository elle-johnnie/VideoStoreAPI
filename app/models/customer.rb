class Customer < ApplicationRecord
  # relationships
  has_many :rentals
  has_many :movies, :through => :rentals

  # validations
  validates :name, presence: true
  validates :registered_at, presence: true
  validates :postal_code, presence: true
  validates :phone, presence: true
  
  def movies_out_count
    return self.rentals.where({checkin_date: nil}).count
  end

end
