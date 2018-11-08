collection @rentals
child :movie do
  attributes :id #rename movie_id, :title
end

node :location do |m|
  { :city => m.city, :address => partial("users/address", :object => m.address) }
end

node :location do |m|
  { :city => m.city, :address => partial("users/address", :object => m.address) }
end

child :customer do
  attributes :id #rename customer_id, :name, :postal_code, :checkout_date, :due_date
end
#
# extends attributes :id, :customer_id, :movie_id, :checkout_date, :checkin_date, :due_date

# node(:movies_checked_out_count) { |customer| movies_out_count(customer) }


# Fields to return:
# - `movie_id`
# - `title` ########
# - `customer_id`
# - `name` ###########
# - `postal_code` ##########
# - `checkout_date`
# - `due_date`

# - Customers can be sorted by `name`, `registered_at` and `postal_code`
# - Movies can be sorted by `title` and `release_date`
# - Overdue rentals can be sorted by `title`, `name`, `checkout_date` and `due_date`



=begin
# => [ { "rental" : { ... } } ]


=end
