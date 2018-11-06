require "test_helper"

describe MoviesController do
  describe 'get api' do
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
      get movies_path(movies(:movie_out).id)
      must_respond_with :success

      # body = JSON.parse(response.body)
      # expect(body.length).must_equal 1
      # expect(body.)
    end

    it 'return a 404 if movie DNE' do
      id = -999
      get movies_path(id), as: :json
      must_respond_with :not_found
    end
  end

  describe 'create api' do
    it 'has a properly defined route' do

    end

    it 'can create a new movie in db with valid data' do

    end

    it 'will not change db if a movie is created w/ garbage data' do

    end
  end

end
