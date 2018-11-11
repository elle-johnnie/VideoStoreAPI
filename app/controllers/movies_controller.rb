class MoviesController < ApplicationController
  before_action :get_query_params, only: [:index] # TODO: add :current and :history

  def index
    movies = Movie.all
    @sorters.each do |sorter|
      movies = movies.order(sorter => :asc) # asc is default - just being explicit
    end

    @movies = movies
  end

  def show
    @movie = Movie.find_by(id: params[:id])
    render json: { ok: false, cause: :not_found }, status: :not_found if @movie.nil?
  end

  def create
    movie_params[:inventory_available] = movie_params[:inventory]
    @movie = Movie.new(movie_params)
    unless @movie.save
      render json: {ok: false, cause: "validation errors", errors: @movie.errors}, status: :bad_request
    end
  end

# TODO: @sorters (user stories do not specify which fields must be sortable)
# SJL: I'm thinking %w(checkout_date due_date name)

  # get '/movies/:id/current'
  def current
    @movie = Movie.find_by(id: params[:id])
    @current = @movie.rentals.where(checkin_date: nil)
    # binding.pry
    if @current.length == 0
      render json: { ok: true, cause: "All copies of #{@movie.title} are checked in" }, status: :ok
    else
      @current
    end
  end

# TODO: @sorters (user stories do not specify which fields must be sortable)
# SJL: I'm thinking %w(checkout_date due_date name)
  def history
    @movie = Movie.find_by(id: params[:id])
    @history = @movie.rentals.where.not(checkin_date: nil)
    # binding.pry
    if @history.length == 0
      render json: { ok: true, cause: "#{@movie.title} has no completed rental history" }, status: :ok
    else
      @history
    end
  end

  private

  def movie_params
     return params.permit(:title, :overview, :release_date, :inventory)
  end

end
