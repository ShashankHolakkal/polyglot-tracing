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

  span = OpenTracing.start_span('client span')

  # invoke to get actual version
  actualUri = URI.parse("http://actual:8080/")
  actualClient = Net::HTTP.new(actualUri.host,actualUri.port)
  actualReq = Net::HTTP::Get.new(actualUri.request_uri)
  OpenTracing.inject(span.context, OpenTracing::FORMAT_RACK, actualReq)
  actualResponse = actualClient.request(actualReq).body

  # invoke to get definition version
  definitionUri = URI.parse("http://defined-service:9090/api/definition")
  definitionClient = Net::HTTP.new(definitionUri.host,definitionUri.port)
  definitionReq = Net::HTTP::Get.new(definitionUri.request_uri)
  OpenTracing.inject(span.context, OpenTracing::FORMAT_RACK, definitionReq)
  definitionResponse = definitionClient.request(definitionReq).body

  return actualResponse << definitionResponse
  span.finish
  # return actualResponse
end
