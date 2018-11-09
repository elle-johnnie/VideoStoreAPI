class RentalsController < ApplicationController
  before_action :get_query_params, only: [:overdue]

  def zomg
    render json: {message: "it works"}
  end

  def check_out
    @rental = Rental.new(rental_params)
    unless @rental.checkout_data && @rental.save
      render json: {ok: false, cause: "validation errors", errors: @rental.errors.messages}, status: :bad_request
    end
  end

  def check_in
    @rental = Rental.find_by(movie_id: params[:movie_id], customer_id: params[:customer_id], checkin_date: nil)
    unless @rental.checkin_data && @rental.save
      render json: {ok: false, cause: "validation errors", errors: @rental.errors.messages}, status: :bad_request
    end
  end

  def overdue
    # overdue_rentals = Rental.where(checkin_date: nil).where("rentals.due_date < ?", Date.current)
    # # @sorters will always be a%w(checkout_date due_date title name) 1-d ordered array of unique values.
    #
    # # %w(checkout_date due_date title name)
    #
    # @sorters.each do |sorter|
    #   case sorter
    #   when "checkout_date" || "due_date"
    #     overdue_rentals = overdue_rentals.order(sorter => :asc) # asc is default - just being explicit
    #   when "title"
    #     overdue_rentals = overdue_rentals.order()
    #   when "name"
    #
    #   end
    # end
    #
    # @overdue_rentals = overdue_rentals

    @overdue_rentals = Rental.where(checkin_date: nil).where("rentals.due_date < ?", Date.current)
  end

  private

  def rental_params
     return params.permit(:customer_id, :movie_id)
  end

end
