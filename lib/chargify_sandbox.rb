require "chargify_sandbox/version"
require 'sinatra/base'
require 'capybara_discoball'
require 'chargify_api_ares'

module ChargifySandbox
  class FakeApi < Sinatra::Base
    get '/subscriptions.json' do
      content_type :json
      fixture('subscriptions')
    end

    get '/customers/:id/subscriptions.json' do
      content_type :json
    end

    get '/subscriptions/:id' do
      content_type :json
      fixture('subscription')
    end

    post '/subscriptions.json' do
      content_type :json
      fixture('subscription')
    end

    put '/subscriptions/:id.json' do
      content_type :json
      fixture('updated_subscription')
    end

    delete '/subscriptions/:id' do
      content_type :json
      fixture('cancelled_subscription')
    end

    private

    def fixture(name)
      File.open("./spec/fixtures/#{name}.json").read
    end
  end
end

Capybara::Discoball::Runner.new(ChargifySandbox::FakeApi) do |server|
  Chargify.configure do |c|
    c.site = server.url
    c.format = :json
  end
end.boot
