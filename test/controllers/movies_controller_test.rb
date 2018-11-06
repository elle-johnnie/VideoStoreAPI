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
    it 'returns an individual response' do
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

    it 'has a properly defined route' do
      expect{
        post movies_path, params: movie_hash, as: :json
      }.must_change 'Movie.count', 1

      value(response).must_be :successful?
      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body.keys).must_equal ["id"]
      expect(body["id"]).must_equal Movie.last.id
    end

    it 'can create a new movie in db with valid data' do

    end

    it 'will not change db if a movie is created w/ garbage data' do

    end
  end

end
