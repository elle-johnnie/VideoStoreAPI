require "test_helper"

describe Movie do


  describe 'Validations' do
    let (:movie) { Movie.new(title: "valid movie",
                             overview: "overview",
                             release_date: Date.today,
                             inventory: 99)
                 }

    it "a movie can be created with all required fields present" do
      movie.save
      movie.valid?.must_equal true
    end

    it "inventory will default to zero" do
      movie.save
      expect(movie.inventory_available).must_equal 0
    end

    it "a movie cannot be created if any required field is not present" do
      fields = [:title, :overview, :release_date, :inventory]
      setters = [:title=, :overview=, :release_date=, :inventory=]
      setters.each_with_index do |setter, index|
        movie.send(setter, nil)
        movie.valid?.must_equal false
        movie.errors.messages.must_include fields[index]
      end
    end
  end

  it 'belongs to movie' do

  end

  it 'belongs to customer' do

  end
end
