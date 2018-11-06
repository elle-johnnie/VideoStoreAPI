require "test_helper"

describe MoviesController do
  describe 'actions' do
    it "should get index" do
      get movies_path, as: :json
      must_respond_with :success
    end

    it 'returns expected fields' do
      fields = %w(id title release_date)
      get movies_path, as: :json
      body = JSON.parse(response.body)
      body.each do |movie|
        movie.keys.sort.must_equal fields
      end
    end

    # it "should get show" do
    #   get movies_show_url
    #   value(response).must_be :success?
    # end
    #
    #
    # it "should get create" do
    #   get movies_create_url
    #   value(response).must_be :success?
    # end
    #
    # it "should get update" do
    #   get movies_update_url
    #   value(response).must_be :success?
    # end
  end
end
