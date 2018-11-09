collection @overdue_rentals
attributes :movie_id, :customer_id, :checkout_date, :due_date
child(:movie) { attributes :title }
child(:customer) { attributes :name, :postal_code }

# [
#   {
#     movie_id: 3,
#     customer_id: 3,
#     checkout_date: "2018-11-05",
#     due_date: "2018-11-06",
#     movie: {
#       title: "Rats And Strangers"
#     },
#     customer: {
#       name: "Roanna Robinson",
#       postal_code: "15867"
#     }
#   }
# ]

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
