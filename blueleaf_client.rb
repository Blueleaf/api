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
    uri = 'https://secure.blueleaf.com/api/v1'
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

token, id = ARGV

if token.nil?
  puts "Usage: ruby blueleaf_client.rb <api_token>"
  puts "       ruby blueleaf_client.rb <api_token> <id>"
  exit
end

client = BlueleafClient.new(token)

if id.nil?
  pp client.advisor
  pp client.households
else
  pp client.household(id)
end
