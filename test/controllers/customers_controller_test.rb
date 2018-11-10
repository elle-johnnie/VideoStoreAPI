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

  describe 'get query params' do
    let (:new_customer) { Customer.new(id: 1,
                                   name: "customer_first",
                                   registered_at: Time.zone.now,
                                   postal_code: "postal_code",
                                   phone: "phone")
                    }

    describe 'sorter' do
      it 'given a single valid sorter, it sorts Customers in ascending order' do
        # valid: name, registered_at, and postal_code
        new_customer.save!
        path = '/customers?sort=registered_at'
        get path, as: :json
        body = JSON.parse(response.body)
        expect(body.first["name"]).must_equal "Zipper Zigzag"
      end

      it 'defaults to id: :asc if the query is nil or an empty string' do
        new_customer.save!
        path = '/customers'
        query_string = ["", "?sort=", "?", "sort="]
        query_string.each do |query|
           path << query
           get path, as: :json
           body = JSON.parse(response.body)
           expect(body.first["name"]).must_equal "customer_first"
        end
      end

      it 'will throw out invalid sorters and default to id' do
        new_customer.save!
        path = '/customers?sort='
        query_string = ["bubble tea", "bubbletea", "address", "phone", "id"]
        query_string.each do |query|
           path << query
           get path, as: :json
           body = JSON.parse(response.body)
           expect(body.first["name"]).must_equal "customer_first"
         end
      end

      it 'given >1 valid sorters, it applies sorters left to right' do
        path = '/customers?sort=postal_code&sort=name'
        get path, as: :json
        body = JSON.parse(response.body)
        expect(body[0]["postal_code"]).must_equal "00000"
        expect(body[1]["name"]).must_equal "Zipper Zigzag"
      end
    end

    describe 'items per page' do
      it 'returns the appropriate # of items per page "n"' do
        get '/customers?n=2', as: :json
        body = JSON.parse(response.body)
        expect(body.length).must_equal 2
      end

    end

    describe 'page number' do
      it 'returns a start page if specified "p"' do
        get '/customers?n=2&p=2', as: :json
        body = JSON.parse(response.body)
        # expect 2nd set of fixtures sorted by id asc order
        expect(body[1]["id"]).must_equal 859843310
      end

    end
  end

end
