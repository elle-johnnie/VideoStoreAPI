require "test_helper"

describe CustomersController do

  describe 'index action' do
    it "should get index" do
      get customers_path, as: :json
      must_respond_with :success
    end

    it 'returns expected fields' do
      fields = %w(id movies_checked_out_count name phone postal_code registered_at)
      get customers_path, as: :json
      body = JSON.parse(response.body)
      body.each do |customer|
        customer.keys.sort.must_equal fields
      end
    end
  end

end
