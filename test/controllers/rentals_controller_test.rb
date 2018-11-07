require "test_helper"

describe RentalsController do
 describe "api actions" do
   let(:new_rental) {
     { customer_id: 859843310,
       movie_id: 400453147
     }
   }
   it 'can checkout a movie' do
     # POST /rentals/check_out
     # binding.pry
     fields = %w(id movie_id customer_id due_date checkout_date checkin_date).sort
     movie_inv_avail_start = Movie.find(400453147).inventory_available
     expect do
       post checkout_path, params: new_rental, as: :json
     end.must_change 'Rental.count', 1
     movie_inv_avail_end = Movie.find(400453147).inventory_available
     value(response).must_be :successful?
     expect(response.header['Content-Type']).must_include 'json'
     body = JSON.parse(response.body)
     body.each do |rental|
       rental.keys.sort.must_equal fields
     end

     expect(body.checkout_date).must_be Date.today
     expect(body.checkin_date).must_be_nil
     expect(body.due_date).must_be Date.today + 7
     expect(movie_inv_avail_end).must_equal movie_inv_avail_start - 1
   end

   it 'can checkin a movie' do
     # POST /rentals/check_inout
     # post '/rentals/check_in'
   end
 end
end
