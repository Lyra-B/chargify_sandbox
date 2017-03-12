require "chargify_sandbox/version"
require 'sinatra/base'
require 'capybara_discoball'
require 'chargify_api_ares'

module ChargifySandbox
  class FakeApi < Sinatra::Base
    get '/subscriptions.json' do
      render :json, 'subscriptions'
    end

    get '/subscriptions/:id' do
      render :json, 'subscription'
    end

    post '/subscriptions.json' do
      render :json, 'subscription'
    end

    put '/subscriptions/:id.json' do
      render :json, 'updated_subscription'
    end

    delete '/subscriptions/:id' do
      render :json, 'cancelled_subscription'
    end

    private

    def render(type, filename)
      content_type(type)
      fixture(filename, type)
    end

    def fixture(filename, type)
      gem_dir = File.dirname(File.expand_path(__FILE__))
      fixtures_path = File.join(gem_dir, "fixtures", "#{filename}.#{type}")
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

