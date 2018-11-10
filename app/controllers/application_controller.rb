class ApplicationController < ActionController::API
  require 'cgi'

private

# Any endpoint that returns a list should accept 3 optional query parameters:
  def get_query_params
    @sorters = permit_sort_params
##################################################################
    @page = permit_p_param        # SJL: these don't do anything
    @num = permit_n_param       # (see note in comment below.)
##################################################################
  end

  def permit_sort_params
    return [:id] unless params[:sort]
    # returns an array of 1+ sort fields (string) that are valid for the model.
    # different controllers accept different sort fields.
    @valid_sorters = {
                      'customers' => %w(name registered_at postal_code),
                      'movies' => %w(title release_date),
                      'rentals' => %w(checkout_date due_date title name) # Just For Overdue Rentals (rentals#overdue)
                    }

# You can't apply the same sorter twice -- the second instance will be ignored
    sorters = CGI.parse(request.query_string)["sort"].uniq
    sorters = sorters.map{|sorter| sorter.gsub(' ', '_')}
    sorters = sorters.select { |sorter| @valid_sorters[controller_name].include?(sorter) }
    return sorters.empty? ? ["id"] : sorters # The default sorter is "id"
  end

##################################################################
# SJL: These sorters haven't been created and don't do anything,
# but this is where it could (and I think should) go.
##################################################################
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
##################################################################

end

# Note on CGI.parse:
      # CGI.parse knows what to do if a query param appears > once in the url.
      # it just adds it to the array!
      # url    = 'http://www.foo.com?id=4&empid=6'
      # uri    = URI.parse(url)
      # params = CGI.parse(uri.query)
      # params is now {"id"=>["4"], "empid"=>["6"]}
# An example based on this app would be:
#       sorters = CGI.parse(request.query_string)
# which would return:
#       { "sort"=>["title", "name", "bogus!", "registered at"], "p" => ["3", "-1", "i love bubble tea"]}
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
