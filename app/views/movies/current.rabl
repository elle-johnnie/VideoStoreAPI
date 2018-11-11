# collection of all movies with in progress rentals
collection @current
attributes :id => :rental_id, :checkout_date => :checked_out, :due_date => :due, :checkin_date => :returned

child :customer do
  attributes :customer_id, :name, :postal_code
end












