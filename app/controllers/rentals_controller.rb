class RentalsController < ApplicationController

  #### `GET /zomg`
  def zomg
    render json: {message: "it_works"}
  end
  # POST RENTALS/CHECK_OUT
  def check_out
    @rental = Rental.new(rental_params)
    unless @rental.checkout_data && @rental.save
      render json: {ok: false, cause: "validation errors", errors: @rental.errors}, status: :bad_request
    end
  end
  # POST RENTALS/CHECK_IN
  def check_in
    @rental = Rental.find_by(movie_id: params[:movie_id], customer_id: params[:customer_id])
    unless @rental.checkin_data && @rental.save
      render json: {ok: false, cause: "validation errors", errors: @rental.errors}, status: :bad_request
    end

  end

  private

  def rental_params
     return params.permit(:customer_id, :movie_id)
  end

end
