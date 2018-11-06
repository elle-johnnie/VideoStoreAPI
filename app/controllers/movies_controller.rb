class MoviesController < ApplicationController
  # GET MOVIES
  def show
    @movie = Movie.find_by(id: params[:id])
  end

  # GET MOVIES
  def index
    @movies = Movie.all
  end

  # POST MOVIES
  def create
  end

  # POST MOVIES
  def update
  end
end
