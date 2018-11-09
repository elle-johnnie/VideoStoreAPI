collection @overdue_rentals
attributes :movie_id
child :movie do |r|
  { :title => r.movie.title }
end
attributes :customer_id
child :customer do |r|
  { :name => r.customer.name,
    :postal_code => r.customer.postal_code}
end
attributes :checkout_date, :due_date

# [ { "rental" :
#     {
#       "movie_id" : "1",
#       "movie" : {
#         "title" : "Mook Kim"
#       },
#       "customer_id" : "1",
#       "customer" : {
#         "name" : "Mook Kim",
#         "postal_code" : "12345"
#       }
#     },
#     "checkout_date" : "[a date]",
#     "due_date" : "[a date]"
#   },
#   { "rental" :
#       {
#         "movie_id" : "1",
#         "movie" : {
#           "title" : "Mook Kim"
#         },
#         "customer_id" : "1",
#         "customer" : {
#           "name" : "Mook Kim",
#           "postal_code" : "12345"
#         }
#       },
#       "checkout_date" : "[a date]",
#       "due_date" : "[a date]"
#     },
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
