require 'rubygems'
require 'pp'
require 'httparty'

class BlueleafClient
  include HTTParty

  base_uri 'https://blueleaf.com/api/v1'

  def initialize(token)
    @options = { :basic_auth => { :username => token } }
  end

  def advisor
    self.class.get('/advisor.xml', @options)
  end

  def households
    self.class.get('/households.xml', @options)
  end

  def household(id)
    self.class.get("/households/#{id}.xml", @options)
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
