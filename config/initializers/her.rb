require 'settings'
require 'faraday_middleware'
require 'her'
require 'her/middleware/json_api_parser'

api_url = ENV['YB_API_URL'] || "#{Settings.yearbook.protocol}://#{Settings.yearbook.api_host}:#{Settings.yearbook.api_port}"

YB = Her::API.new
YB.setup url: api_url do |c|
  # Request
  c.use FaradayMiddleware::EncodeJson
  # Response
  c.use Her::Middleware::JsonApiParser
  c.use Faraday::Adapter::NetHttp
end
