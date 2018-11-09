class MoviesController < ApplicationController
  before_action :get_query_params, only: [:index]

  #### `GET /movies`
  # List all movies
  #
  # Fields to return:
  # - `id`
  # - `title`
  # - `release_date`
  def index
    movies = Movie.all
    @sorters.each do |sorter|
      movies = movies.order(sorter => :asc) # asc is default - just being explicit
    end

    @movies = movies
  end

  #### `GET /movies/:id`
  # Look a movie up by `id`
  # URI parameters:
  # - `id`: Movie identifier

  # Fields to return:
  # - `title`
  # - `overview`
  # - `release_date`
  # - `inventory` (total)
  # - `available_inventory` (not currently checked-out to a customer)
  # - This will be the same as `inventory` unless you've completed the optional endpoints.
  def show
    @movie = Movie.find_by(id: params[:id])
    render json: { ok: false, cause: :not_found }, status: :not_found if @movie.nil?
  end


  #### `POST /movies`
  # Create a new movie in the video store inventory.
  #
  # Upon success, this request should return the `id` of the movie created.
  #
  # Request body:
  #
  # | Field         | Datatype            | Description
  # |---------------|---------------------|------------
  # | `title` | string             | Title of the movie
  # | `overview` | string | Descriptive summary of the movie
  # | `release_date` | string `YYYY-MM-DD` | Date the movie was released
  # | `inventory` | integer | Quantity available in the video store
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







# # PATCH MOVIES
# def update
#   @movie = Movie.find_by(id: params[:id])
#   @movie.update(movie_params)
#
#   if !@movie.valid?
#     render json: {ok: false, cause: "validation errors", errors: @movie.errors}, status: :bad_request
#   end
# end
