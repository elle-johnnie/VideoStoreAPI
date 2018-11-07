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
end

