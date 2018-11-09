class CustomersController < ApplicationController
  before_action :get_query_params, only: [:index]

  def index
    customers = Customer.all
    @sorters.each do |sorter|
      customers = customers.order(sorter => :asc) # asc is default - just being explicit
    end

    @customers = customers
  end
end
