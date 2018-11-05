require "test_helper"

describe Customer do
  let(:customer) { Customer.new }

  it "must be valid" do
    value(customer).must_be :valid?
  end

  describe 'relationships' do
    it 'can have many rentals' do

    end

    it 'has many movies through rentals' do

    end


  end
end
