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
      gem_dir = File.dirname(File.expand_path(__FILE__))
      fixtures_path = File.join(gem_dir, "fixtures", "#{name}.json")
      File.open(fixtures_path).read
    end
  end

  def self.boot
    Capybara::Discoball::Runner.new(FakeApi) do |server|
      Chargify.configure do |c|
        c.site = server.url
        c.format = :json
      end
    end.boot
  end
end

