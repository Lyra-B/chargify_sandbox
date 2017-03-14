require 'spec_helper'
require 'pry'
require 'chargify_sandbox'

describe 'ChargifySandbox' do
  include Rack::Test::Methods

  def app
    ChargifySandbox::FakeApi.new
  end

  before do
    ChargifySandbox.boot
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
        subscription = Chargify::Subscription.create(customer_reference: 'moklett')

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

    describe 'DELETE /subscriptions/:id.json' do
      it 'cancels the subscription' do
        subscription = Chargify::Subscription.find(2000)
        
        response = JSON.parse(subscription.cancel.body, symbolize_names: true)

        expect(response[:subscription][:state]).to eq('cancelled') 
      end
    end
  end

  describe 'Customers' do
    describe 'GET /customers.json' do
      it 'returns all customers' do
        customers = Chargify::Customer.find(:all)

        expect(customers.count).to eq(3)
      end
    end

    describe 'GET /customers/:id.json' do
      it 'returns a customer' do
        customer = Chargify::Customer.find(1)

        expect(customer.first_name).to eq('non')
      end
    end

    describe 'GET /customers/lookup.json' do
      it 'returns a customer by reference' do
        customer = Chargify::Customer.find(1)
        customer_by_reference = Chargify::Customer.find_by_reference('12345')

        expect(customer).to eq(customer_by_reference)
      end
    end

    describe 'POST /customers.json' do
      it 'creates a new customer' do
        customer = Chargify::Customer.create(first_name: "non")

        expect(customer.first_name).to eq('non')
      end
    end

    describe 'PUT /customers/:id.json' do
      it 'updates the customer' do
        customer = Chargify::Customer.find(1)
        
        customer.first_name = 'John'

        expect(customer.save).to be_truthy
      end
    end

    describe 'DELETE /customers/:id.json' do
      it 'deletes a customer' do
        customer = Chargify::Customer.find(1)
        
        expect(customer.destroy).to be_truthy
      end
    end

    describe 'GET /customers/:id/subscriptions.json' do
      it 'returns the customer subscriptions' do
        customer = Chargify::Customer.find(1)

        subscriptions = customer.subscriptions

        expect(subscriptions.count).to eq(2)
      end
    end
  end
end


