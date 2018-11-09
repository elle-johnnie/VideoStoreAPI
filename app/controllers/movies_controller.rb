class MoviesController < ApplicationController
  before_action :get_query_params, only: [:index, :overdue]

  def index
    movies = Movie.all
    @sorters.each do |sorter|
      movies = movies.order(sorter => :asc) # asc is default - just being explicit
    end

    @movies = movies
  end

  def show
    @movie = Movie.find_by(id: params[:id])
    render json: {ok: false, cause: :not_found}, status: :not_found if @movie.nil?
  end

  def create
    movie_params[:inventory_available] = movie_params[:inventory]
    @movie = Movie.new(movie_params)
    unless @movie.save
      render json: {ok: false, cause: "validation errors", errors: @movie.errors}, status: :bad_request
    end
  end

  private

  def movie_params
     return params.permit(:title, :overview, :release_date, :inventory)
  end

end
