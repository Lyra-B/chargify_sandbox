require 'spec_helper'
require 'pry'
require 'chargify_sandbox'

describe 'ChargifySandbox' do
  include Rack::Test::Methods

  def app
    ChargifySandbox::FakeApi.new
  end

  describe 'Subscriptions' do
    describe 'GET /subscriptions.json' do
      it 'returns all subscriptions' do
        subscriptions = Chargify::Subscription.find(:all)
  
        expect(subscriptions.count).to eq(2)
      end
    end

    describe 'GET /subscriptions/:id.json' do
      it 'returns the subscription' do
        subscription = Chargify::Subscription.find(2000)

        expect(subscription.customer_id).to eq(2000)
      end
    end

    describe 'POST /subscriptions.json' do
      it 'creates a new subscription' do
        subscription = Chargify::Subscription.create(
          :customer_reference => 'moklett',
          :product_handle => 'chargify-api-ares-test',
          :credit_card_attributes => {
            :first_name => "Michael",
            :last_name => "Klett",
            :expiration_month => 1,
            :expiration_year => 2020,
            :full_number => "1"
          }
        )

        expect(subscription.customer_reference).to eq('moklett')
      end
    end

    describe 'PUT /subscriptions/:id.json' do
      it 'updates the subscription' do
        subscription = Chargify::Subscription.find(2000)

        subscription.credit_card_attributes = { full_number: '123' }
        subscription.save
        
        expect(subscription.credit_card_attributes.full_number).to eq('123')
      end
    end

    describe 'DELETE /subscriptions/id.json' do
      it 'cancels the subscription' do
        subscription = Chargify::Subscription.find(2000)
        
        response = JSON.parse(subscription.cancel.body, symbolize_names: true)

        expect(response[:subscription][:state]).to eq('cancelled') 
      end
    end
  end
end


