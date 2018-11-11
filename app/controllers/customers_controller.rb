class CustomersController < ApplicationController
  before_action :get_query_params, only: [:index] # TODO: add :current and :history

  def index
    customers = Customer.all

    @sorters.each do |sorter|
      customers = customers.paginate(:page => @page, :per_page => @num).order(sorter => :asc)
                                    # asc is default - just being explicit
    end
    @customers = customers
  end

# TODO: @sorters (user stories do not specify which fields must be sortable)
# SJL: I'm thinking %w(checkout_date due_date title)
  def current
    @customer = Customer.find_by(id: params[:id])
    @current = @customer.rentals.where(checkin_date: nil)

    if @current.length == 0
      render json: { ok: true, cause: "#{@customer.name} has no movies checked out" }, status: :ok
    else
      @current
    end
  end

# TODO: @sorters (user stories do not specify which fields must be sortable)
# SJL: I'm thinking %w(checkout_date due_date title)
  def history
    @customer = Customer.find_by(id: params[:id])
    @history = @customer.rentals.where.not(checkin_date: nil)
    # binding.pry
    if @history.length == 0
      render json: { ok: true, cause: "#{@customer.name} has no completed rental history" }, status: :ok
    else
      @history
    end
  end

end
