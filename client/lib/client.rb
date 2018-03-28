require 'sinatra'
#require 'JSON'
require "net/http"
require "uri"

require 'opentracing'
require 'jaeger/client'
require 'rack/tracer'

# Listen on all interfaces in the development environment
set :bind, '0.0.0.0'

OpenTracing.global_tracer = Jaeger::Client.build(host: 'jaeger', port: 6831, service_name: 'client')

use Rack::Tracer

# view one
get '/' do

  actualUri = URI.parse("http://actual:8080/")

  # Shortcut
  # actualResponse = Net::HTTP.get_response(actualUri)

  # return actualResponse.body

  # definitionUri = URI.parse("http://localhost:8090/api/definition")

  # Shortcut
  # definitionResponse = Net::HTTP.get_response(definitionUri)

  # return actualResponse.body << definitionResponse.body

  puts 'In here.'

  client = Net::HTTP.new(actualUri.host,actualUri.port)
  req = Net::HTTP::Get.new(actualUri.request_uri)
  span = OpenTracing.start_span('client span')
  OpenTracing.inject(span.context, OpenTracing::FORMAT_RACK, req)
  puts client.request(req).body
  span.finish
  # return actualResponse
end

