require "test_helper"

describe MoviesController do
  describe 'get api - index' do
    it "is working route that returns json" do
      # Act
      get movies_path, as: :json
      # Assert
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it 'returns an array' do
      get movies_path, as: :json
      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Array
    end

    it 'returns expected fields' do
      fields = %w(id release_date title)
      get movies_path, as: :json
      body = JSON.parse(response.body)
      body.each do |movie|
        movie.keys.sort.must_equal fields
      end
    end
  end


  describe 'show api' do
    it 'returns an individual response with expected fields' do
      get movie_path(Movie.first.id), as: :json
      must_respond_with :success
      body = JSON.parse(response.body)

      fields = %w(id title overview release_date inventory inventory_available).sort
      expect(body.keys.sort).must_equal fields
    end

    it 'return a 404 if movie DNE' do
      id = -999
      get movie_path(id), as: :json
      must_respond_with :not_found

      body = JSON.parse(response.body)
      expect(body["ok"]).must_equal false
      expect(body["cause"]).must_equal "not_found"
    end
  end

  describe 'create api (post)' do
    let (:movie_hash) {
                       {title: "test movie",
                       overview: "spoiler alert!",
                       release_date: Date.yesterday,
                       inventory: 99
                      }
    }

    it 'can create a new movie in db with valid data and return an id' do
      expect{
        post movies_path, params: movie_hash, as: :json
      }.must_change 'Movie.count', 1

      value(response).must_be :successful?
      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body.keys).must_equal ["id"]
      expect(body["id"]).must_equal Movie.last.id
    end

    it 'will not change db if a movie is created w/ garbage data' do
      movie_hash[:title] = nil
      expect{
        post movies_path, params: movie_hash, as: :json
      }.wont_change 'Movie.count'
      body = JSON.parse(response.body)
      must_respond_with :bad_request
      expect(body["ok"]).must_equal false
      expect(body["cause"]).must_equal "validation errors"
      expect(body["errors"].keys).must_include "title"
    end
  end

  describe 'get query params' do
    let (:new_movie) { Movie.new(id: 1,
                                 title: "movie_first",
                                 overview: "watch me",
                                 release_date: Date.current,
                                 inventory: 5,
                                 inventory_available: 0)
                    }
    describe 'sorter' do
      it 'given a single valid sorter, it sorts Movies in ascending order' do
        # valid: title, release_date
        path = '/movies?sort=title'
        get path, as: :json
        body = JSON.parse(response.body)
        expect(body.last["title"]).must_equal "CATTACA"
      end

      it 'defaults to id: :asc if the query is nil or an empty string' do
        new_movie.save!
        path = '/movies'
        query_string = ["", "?sort=", "?", "sort="]
        query_string.each do |query|
           path << query
           get path, as: :json
           body = JSON.parse(response.body)
           expect(body.first["title"]).must_equal "movie_first"
        end
      end

      it 'will throw out invalid sorters and default to id' do
        new_movie.save!
        path = '/movies?sort='
        query_string = ["bubble tea", "bubbletea", "overview", "inventory", "inventory_available"]
        query_string.each do |query|
           path << query
           get path, as: :json
           body = JSON.parse(response.body)
           expect(body.first["title"]).must_equal "movie_first"
         end
      end

      it 'given >1 valid sorters, it applies sorters left to right' do
        path = '/movies?sort=release_date&sort=title'
        get path, as: :json
        body = JSON.parse(response.body)
        expect(body[0]["title"]).must_equal "Bend It Like It Like That"
        expect(body[1]["title"]).must_equal "CATTACA"
      end
    end


    describe 'endpoints' do
      let(:rental) {
        { customer_id: Customer.first.id,
          movie_id: Movie.last.id
        }
      }
      it 'can list all rentals that are currently checked out' do
        # clear all rental data
        Rental.destroy_all
        # the movie gets checked out by the first customer
        post check_out_path, params: rental, as: :json

        id = Movie.last.id
        get "/movies/#{id}/current", as: :json
        value(response).must_be :successful?
        fields = %w(rental_id checked_out due returned customer)
        body = JSON.parse(response.body)
        # returns JSON of expected fields, sort fields
        body.each do |customer|
          expect(customer.keys.sort).must_equal fields.sort
        end
       
        expect(body[0]["customer"].keys).must_include "name"
        expect(body[0]["customer"]["postal_code"]).must_equal Customer.first.postal_code
        # count movies in array with nil checkin date
        expect(body.count).must_equal 1
        post check_out_path, params: rental, as: :json


        get "/movies/#{id}/current", as: :json
        body = JSON.parse(response.body)
        expect(body.count).must_equal 2
      end

      it 'can list all rental history for completed rentals' do
        # clear all rental data
        Rental.destroy_all
        id = Movie.last.id
        # the movie gets checked out by the first customer
        post check_out_path, params: rental, as: :json
        # return movie to provide a history
        post check_in_path, params: rental, as: :json

        get "/movies/#{id}/history", as: :json
        value(response).must_be :successful?
        fields = %w(rental_id checked_out due returned customer)
        body = JSON.parse(response.body)
        # returns JSON of expected fields, sort fields
        body.each do |customer|
          expect(customer.keys.sort).must_equal fields.sort
        end
        expect(body[0]["customer"].keys).must_include "name"
        expect(body.count).must_equal 1

        expect(body[0]["customer"]["name"]).must_equal Customer.first.name
        expect(body[0]["customer"]["postal_code"]).must_equal Customer.first.postal_code
      end
    end
  end
end


