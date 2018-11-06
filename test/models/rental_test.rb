require "test_helper"

describe Rental do
  describe 'Validations' do
    let (:rental) { Rental.new(checkout_date: Date.today,
                               due_date: Date.tomorrow,
                               customer: customers(:customer_out),
                               movie: movies(:movie_in))
                  }

    it "a rental can be created with all required fields present" do
      rental.save
      rental.valid?.must_equal true
    end

    it "a rental cannot be created if any required field is not present" do
      fields = [:checkout_date, :due_date, :customer, :movie]
      setters = [:checkout_date=, :due_date=, :customer=, :movie=]
      setters.each_with_index do |setter, index|
        rental.send(setter, nil)
        rental.valid?.must_equal false
        rental.errors.messages.must_include fields[index]
      end
    end
  end
end
