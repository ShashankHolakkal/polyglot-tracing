require 'sinatra'
#require 'JSON'
require "net/http"
require "uri"

require 'opentracing'
require 'jaeger/client'
require 'rack/tracer'

OpenTracing.global_tracer = Jaeger::Client.build(service_name: 'client')

use Rack::Tracer



# view one
get '/' do

  # actualUri = URI.parse("http://localhost:8080/")

  # Shortcut
  # actualResponse = Net::HTTP.get_response(actualUri)

  # return actualResponse.body

  # definitionUri = URI.parse("http://localhost:8090/api/definition")

  # Shortcut
  # definitionResponse = Net::HTTP.get_response(definitionUri)

  # return actualResponse.body << definitionResponse.body

  puts 'In here.'

  client = Net::HTTP.new("localhost",8080)
  req = Net::HTTP::Get.new("/")
  span = OpenTracing.start_span('client span')
  OpenTracing.inject(span.context, OpenTracing::FORMAT_RACK, req)
  client.request(req).body
  span.finish
  # return actualResponse
end

