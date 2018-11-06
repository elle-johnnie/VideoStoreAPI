class CustomersController < ApplicationController
  # GET CUSTOMERS
  def index
    @customers = Customer.all
    # render json: customers.as_json(only: :id, :name, :registered_at, :postal_code)
  end
end
