require "test_helper"

describe Rental do
  let(:rental) { Rental.new }

  it "must be valid" do
    value(rental).must_be :valid?
  end
end
