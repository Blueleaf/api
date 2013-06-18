#!/usr/bin/env ruby

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

  def initialize(token = nil)
    uri = 'https://secure.blueleaf.com/api/v1'; token ||= 'TDMSMK66W43oaadT5WZ3JWPa'
    # uri = 'https://build.blueleaf.com/api/v1'
    # uri = 'http://localhost:3000/api/v1'; token ||= '5sBT4wCAWimuOZ8JEH5UMbAt'
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

  def schema
    http_client.get "/schema"
  end

  def transactions(date)
    http_client.get "/transactions.xml?date=#{date}"
  end

  def household_transactions(id, date)
    http_client.get "/households/#{id}/transactions.xml?date=#{date}"
  end
end

# token, id = ARGV
id, token, date, sub_id = ARGV
token = ENV['BL_API_TOKEN'] unless token.to_s.length > 0

# if token.nil?
#   puts "Usage: ruby blueleaf_client.rb <api_token>"
#   puts "       ruby blueleaf_client.rb <api_token> <id>"
#   exit
# end

client = BlueleafClient.new(token)

case
when id.nil? || id.empty?
  print client.advisor.body
  print client.households.body
when id == 'schema'
  print client.schema.body
when sub_id && id == 'transactions'
  print client.household_transactions(sub_id, date).body
when id == 'transactions'
  print client.transactions(date).body
else
  print client.household(id).body
end
