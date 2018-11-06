require "test_helper"

describe  Rental do
  describe 'relationships' do
    let(:rental) { rentals(:rental_in)  }

    it 'belongs to a customer' do
      # Arrange (done with let)

      # Act
      customer = rental.customer

      # Assert
      expect(customer).must_be_instance_of Customer
      expect(customer.id).must_equal rental.customer_id
    end

    it 'belongs to a movie' do
      # Arrange (done with let)

      # Act
      movie = rental.movie

      # Assert
      expect(movie).must_be_instance_of Movie
      expect(movie.id).must_equal rental.movie_id
    end
  end
end
