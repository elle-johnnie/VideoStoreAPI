class RentalsController < ApplicationController
  protect_from_forgery with: :null_session

  # GET RENTALS
  def index
  end

  # GET RENTALS
  def show
  end

  # GET RENTALS
  def zomg
    render json: {message: "it_works"}
  end

  # POST RENTALS
  def update
  end

  # POST RENTALS
  def check_out

  end

  # POST RENTALS
  def check_in

  end


end
