require "test_helper"

describe Customer do

  describe 'Validations' do
    let (:new_customer) { Customer.new(name: "valid customer",
                                   registered_at: Time.zone.now,
                                   postal_code: "postal_code",
                                   phone: "phone")
                    }

    it "a customer can be created with all required fields present" do
      new_customer.save
      new_customer.valid?.must_equal true
    end

    it "a customer cannot be created if any required field is not present" do
      fields = [:name, :registered_at, :postal_code, :phone]
      setters = [:name=, :registered_at=, :postal_code=, :phone=]
      setters.each_with_index do |setter, index|
        new_customer.send(setter, nil)
        new_customer.valid?.must_equal false
        new_customer.errors.messages.must_include fields[index]
      end
    end
  end

end


  describe 'relationships' do
    let(:cust) { customers(:customer_out) }
    it 'can have many rentals' do
      rents = cust.rentals

      expect(rents.length).must_be :>, 1
      rents.each do |r|
        expect(r).must_be_instance_of Rental
      end
    end

    it 'can have many movies through rentals' do
      movies = cust.movies
      # binding.pry
      expect(movies.length).must_be :>, 1
      movies.each do |m|
        expect(m).must_be_instance_of Movie
      end
    end


  end
end



# describe 'Custom Methods' do
#   it 'movies_out_count is correct for customers with rental history' do
#     expect(customers(:customer_out).movies_out_count).must_equal 1
#     expect(customers(:customer_in).movies_out_count).must_equal 0
#   end
#
#   it 'movies_out_count works on a customer with no rentals' do
#     Rental.destroy_all
#     expect(customers(:customer_out).rentals.count).must_equal 0
#     expect(customers(:customer_out).movies_out_count).must_equal 0
#   end
# end
