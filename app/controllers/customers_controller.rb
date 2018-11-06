class CustomersController < ApplicationController
  # GET CUSTOMERS
  def index
    @customers = Customer.all
  end
end
