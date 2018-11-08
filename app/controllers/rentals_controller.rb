class RentalsController < ApplicationController
  #### `GET /zomg`
  def zomg
    render json: {message: "it_works"}
  end
  # post check_out_path with params
  def check_out
    @rental = Rental.new(rental_params)
    unless @rental.checkout_data && @rental.save
      render json: {ok: false, cause: "validation errors", errors: @rental.errors}, status: :bad_request
    end
  end
  # post check_in_path with params

  def check_in
    @rental = Rental.find_by(movie_id: params[:movie_id], customer_id: params[:customer_id], checkin_date: nil)
    unless @rental.checkin_data && @rental.save
      render json: {ok: false, cause: "validation errors", errors: @rental.errors}, status: :bad_request
    end
  end

  private

  def rental_params
     return params.permit(:customer_id, :movie_id)
  end

end
