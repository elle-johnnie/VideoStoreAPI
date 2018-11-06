module CustomersHelper

  def movies_out_count(customer)
    return customer.rentals.where({checkin_date: nil}).count
  end

end
