require "test_helper"

describe Movie do
  let(:movie) { Movie.new }

  it "must be valid" do
    value(movie).must_be :valid?
  end

  it 'belongs to movie' do

  end

  it 'belongs to customer' do

  end
end
