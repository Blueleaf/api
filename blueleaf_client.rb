require 'rubygems'
require 'pp'
require 'httparty'

class HttpClient
  include HTTParty

  def initialize(uri, token)
    self.class.base_uri uri
    @options = { :basic_auth => { :username => token } }
  end

  def get(query)
    self.class.get(query, @options)
  end
end

class BlueleafClient

  attr_reader :http_client

  def initialize(token)
    # base_uri 'https://blueleaf.com/api/v1'
    uri = 'https://build.blueleaf.com/api/v1'

    @http_client = HttpClient.new(uri, token)
  end

  def advisor
    http_client.get '/advisor.xml'
  end

  def households
   http_client.get '/households.xml'
  end

  def household(id)
   http_client.get "/households/#{id}.xml"
  end

end

if ARGV.empty?
  puts "Usage: ruby blueleaf_client.rb <api_token>"
  exit
else
  client = BlueleafClient.new(ARGV.first)

  advisor = client.advisor

  households = client.households

  household = client.household(households.first.last.first['id'])

  pp advisor
  pp households
  pp household
end
