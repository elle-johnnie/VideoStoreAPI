# collection of all customer(:id)'s current rentals
collection @current
attributes :id => :rental_id, :checkout_date => :checked_out, :due_date => :due, :checkin_date => :returned


child :movie do
  attribute :title
end
