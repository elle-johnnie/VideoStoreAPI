require "test_helper"

describe Rental do
  let (:rental_in) { rentals(:rental_in)}
  let (:rental_out) {rentals(:rental_out)}

  describe 'Validations' do
    let (:new_rental) { Rental.new(checkout_date: Date.current,
                               due_date: Date.tomorrow,
                               customer: customers(:customer_out),
                               movie: movies(:movie_in))
                  }

    it "a rental can be created with all required fields present" do
      new_rental.save
      new_rental.valid?.must_equal true
    end

    it "a rental cannot be created if any required field is not present" do
      fields = [:checkout_date, :due_date, :customer, :movie]
      setters = [:checkout_date=, :due_date=, :customer=, :movie=]
      setters.each_with_index do |setter, index|
        new_rental.send(setter, nil)
        new_rental.valid?.must_equal false
        new_rental.errors.messages.must_include fields[index]
      end
    end
  end

  describe 'Custom Methods' do
    it 'a rental is complete if it has a checkin date' do
      expect(rental_in.complete?).must_equal true
    end

    it 'a rental is not complete if it does not have a checkin date' do
      expect(rental_out.complete?).must_equal false
    end
  end


  describe 'relationships' do

    it 'belongs to a customer' do
      # Arrange (done with let)

      # Act
      customer = rental_in.customer

      # Assert
      expect(customer).must_be_instance_of Customer
      expect(customer.id).must_equal rental_in.customer_id
    end

    it 'belongs to a movie' do
      # Arrange (done with let)

      # Act
      movie = rental_in.movie

      # Assert
      expect(movie).must_be_instance_of Movie
      expect(movie.id).must_equal rental_in.movie_id
    end
  end
end
