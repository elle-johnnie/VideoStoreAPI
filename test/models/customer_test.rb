require "test_helper"

describe Customer do


  describe 'Validations' do
    let (:customer) { Customer.new(name: "valid customer",
                                   registered_at: Time.zone.now,
                                   postal_code: "postal_code",
                                   phone: "phone")
                    }

    it "a customer can be created with all required fields present" do
      customer.save
      customer.valid?.must_equal true
    end

    it "a customer cannot be created if any required field is not present" do
      fields = [:name, :registered_at, :postal_code, :phone]
      setters = [:name=, :registered_at=, :postal_code=, :phone=]
      setters.each_with_index do |setter, index|
        customer.send(setter, nil)
        customer.valid?.must_equal false
        customer.errors.messages.must_include fields[index]
      end
    end
  end

  describe 'relationships' do
    it 'can have many rentals' do

    end

    it 'has many movies through rentals' do

    end


  end
end
