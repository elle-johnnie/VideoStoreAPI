class ApplicationController < ActionController::API
  require 'cgi'

private

# User story: Any endpoint that returns a list should accept 3 optional query
# parameters.
#
# The methods called within get_query_params parse query params
# and return permitted params as instance variables.
# To run this code before any controller action (and access these instance
# variables), add this to the top of your controller class:
# ` before_action :get_query_params, only: [ <controller action(s)> ] `
  def get_query_params
    @sorters = permit_sort_params
    @page = permit_p_param
    @num = permit_n_param
  end

  # This method returns a 1-D ordered Array of 1+ unique "sorters" (String)
  # that are permitted for the controller calling this method.
  # A "sorter" is the name of the JSON field to sort by.
  # Each controller action permits different sort fields (@valid_sorters).
  # You can't apply the same sorter more than once (occurrences after the first
  # will be ignored).
  # If there are multiple sorters, they are applied L --> R.
  # The default sorter is "id".
  def permit_sort_params
    return [:id] unless params[:sort]
    valid_sorters = {
                      'customers' =>
                        { 'index' => %w(name registered_at postal_code),
                          'history' => %w(checkout_date due_date title)
                        },
                      'movies' =>
                        { 'index' => %w(title release_date),
                          'history' => %w(checkout_date due_date name)
                        },
                      'rentals' =>
                        { 'overdue' => %w(checkout_date due_date title name)
                        }
                    }

    sorters = CGI.parse(request.query_string)["sort"].uniq
    sorters = sorters.map{|sorter| sorter.gsub(' ', '_')}
    sorters = sorters.select { |sorter| valid_sorters[controller_name][action_name].include?(sorter) }
    return sorters.empty? ? ["id"] : sorters
  end

  def permit_n_param
    if params[:n]
      num = CGI.parse(request.query_string)["n"].uniq
      num = num.map{|np| np.gsub(' ', '')}
      # binding.pry
      return num.empty? ? 1 : num.first.to_i
    end
  end

  def permit_p_param
    if params[:p]
      # return 1 integer (see will_paginate gem)
      page = CGI.parse(request.query_string)["p"].uniq
      page = page.map{|p| p.gsub(' ', '')}
      # binding.pry
      return page.empty? ? 10 : page.first.to_i
    end
  end
end

# Note on CGI.parse:
      # CGI.parse knows what to do if a query param appears > once in the url.
      # it just adds it to the array!
      # url    = 'http://www.foo.com?id=4&empid=6'
      # uri    = URI.parse(url)
      # params = CGI.parse(uri.query)
      # params is now {"id"=>["4"], "empid"=>["6"]}
# An example based on this app would be:
#      request.query_string = "sort=title&sort=title&sort=name&sort=bogus!& \
#                              sort=registered%20at&p=3&p=-1&p=i+love+bubble+tea"
#      params = CGI.parse(request.query_string)
# which would return:
#      { "sort"=>["title", "title", "name", "bogus!", "registered at"],
#        "p" => ["3", "-1", "i love bubble tea"] }
#
#
#
#
# From README:
# Any endpoint that returns a list should accept 3 optional query parameters:
#
# Name	Value	Description
# sort	string	Sort objects by this field, in ascending order
# n	integer	Number of responses to return per page
# p	integer	Page of responses to return
# So, for an API endpoint like GET /customers, the following requests should be valid:
#
# GET /customers: All customers, sorted by ID
# GET /customers?sort=name: All customers, sorted by name
# GET /customers?n=10&p=2: Customers 10-19, sorted by ID
# GET /customers?sort=name&n=10&p=2: Customers 10-19, sorted by name
# Of course, adding new features means you should be adding new controller tests to verify them.
#
# Things to note:
#
# Sorting by ID is the rails default
# Possible sort fields:
# Customers can be sorted by name, registered_at and postal_code
# Movies can be sorted by title and release_date
# Overdue rentals can be sorted by title, name, checkout_date and due_date
# If the client requests both sorting and pagination, pagination should be relative to the sorted order
# Check out the will_paginate gem
