require "test_helper"
require 'date'

describe RentalsController do
  let(:rental) {
   { customer_id: 859843310,
     movie_id: 400453147
   }
  }

  it 'can checkout a movie' do
   # POST /rentals/check_out
   fields = %w(id movie_id customer_id due_date checkout_date checkin_date).sort
   movie_inv_avail_start = Movie.find(400453147).inventory_available
   expect do
     post check_out_path, params: rental, as: :json
   end.must_change 'Rental.count', 1

   movie_inv_avail_end = Movie.find(400453147).inventory_available
   value(response).must_be :successful?

   expect(response.header['Content-Type']).must_include 'json'
   body = JSON.parse(response.body)

   expect(body.keys.sort).must_equal fields
   expect(body["checkout_date"]).must_equal Date.today.to_s
   expect(body["checkin_date"]).must_be_nil
   expect(body["due_date"]).must_equal (Date.today + 7).to_s
   expect(movie_inv_avail_end).must_equal movie_inv_avail_start - 1
  end

  it 'can checkin a movie' do
   # post '/rentals/check_in'
   fields = %w(id movie_id customer_id due_date checkout_date checkin_date).sort
   post check_out_path, params: rental
   movie_inv_avail_start = Movie.find(400453147).inventory_available

   expect do
     post check_in_path, params: rental, as: :json
   end.wont_change 'Rental.count'

   movie_inv_avail_end = Movie.find(400453147).inventory_available
   value(response).must_be :successful?

   expect(response.header['Content-Type']).must_include 'json'
   body = JSON.parse(response.body)

   expect(body.keys.sort).must_equal fields
   expect(body["checkin_date"]).must_equal Date.today.to_s
   expect(movie_inv_avail_end).must_equal movie_inv_avail_start + 1
  end

  describe 'SJL: mimicking the postman wave3 smoke test' do
    let (:customer) { customers(:customer_out)}
    let (:movie) { movies(:movie_in)}
    let(:new_rental_params) {
     { customer_id: customer.id,
       movie_id: movie.id
     }
    }
    it 'checking OUT a movie increases customer mcoc count by one' do

      # ARRANGE: FIND CUSTOMER, CHECK START COUNT
      # CUSTOMER CHECKS OUT A MOVIE
      get customers_path, as: :json
      body = JSON.parse(response.body) # array of all customers
      body = body.select {|cust| cust["id"] == customer.id} # array of a single customer hash
      mcoc_start = body[0]["movies_checked_out_count"]

      expect(mcoc_start).must_equal 3 # just to be sure of our fixtures

      post check_out_path, params: new_rental_params, as: :json
      value(response).must_be :successful?

      # # ACT: FIND SAME CUSTOMER, CHECK END COUNT
      get customers_path, as: :json
      body2 = JSON.parse(response.body) # array of all customers
      body2.select {|cust| cust["id"] == customer.id} # array of a single customer hash

      # # ASSERT: END COUNT = START COUNT + 1
      mcoc_end = body2[0]["movies_checked_out_count"]
      expect(mcoc_end).must_equal (mcoc_start + 1)
      expect(mcoc_end).must_equal 4 # just to be sure again.
    end

    it 'checking IN a movie decreases customer mcoc count by one' do
      # ZERO
      get customers_path, as: :json
      value(response).must_be :successful?
      body = JSON.parse(response.body) # array of all customers
      body = body.select {|cust| cust["id"] == customer.id} # array of a single customer hash
      mcoc_zero = body[0]["movies_checked_out_count"]
      expect(mcoc_zero).must_equal 3 # from fixtures

      # CHECK OUT
      post check_out_path, params: new_rental_params, as: :json
      value(response).must_be :successful?

      # BEFORE
      get customers_path, as: :json
      value(response).must_be :successful?
      body2 = JSON.parse(response.body) # array of all customers
      body2.select {|cust| cust["id"] == customer.id}
      mcoc_before = body2[0]["movies_checked_out_count"]
      expect(mcoc_before).must_equal 4 # mcoc_zero + 1

      # CHECK IN
      post check_out_path, params: new_rental_params, as: :json
      value(response).must_be :successful?

      # AFTER
      get customers_path, as: :json
      value(response).must_be :successful?
      body3 = JSON.parse(response.body) # array of all customers
      body3.select {|cust| cust["id"] == customer.id}
      mcoc_end = body3[0]["movies_checked_out_count"]
      expect(mcoc_end).must_equal 3 #mcoc_zero
    end
  end
end
