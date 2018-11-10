class CustomersController < ApplicationController
  before_action :get_query_params, only: [:index]


  def index
    customers = Customer.all

    @sorters.each do |sorter|
      customers = customers.paginate(:page => @page, :per_page => @num).order(sorter => :asc) # asc is default - just being explicit
    end
    @customers = customers
    # binding.pry
    # @customers = customers.paginate(:page => @per_page)
  end
end
