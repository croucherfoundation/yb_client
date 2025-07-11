require 'faraday'
require 'json'
require 'her'
require 'her/middleware/json_api_parser'

api_url = ENV['YB_API_URL']

YB = Her::API.new
YB.setup url: api_url do |c|
  # Request: encode JSON manually
  c.request :json

  # Response: parse JSON API
  c.use Her::Middleware::JsonApiParser

  # Adapter
  c.adapter Faraday.default_adapter
end
