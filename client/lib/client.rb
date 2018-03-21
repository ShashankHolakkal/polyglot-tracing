require 'sinatra'
#require 'JSON'
require "net/http"
require "uri"

# view one
get '/' do

  actualUri = URI.parse("http://localhost:8080/")

  # Shortcut
  actualResponse = Net::HTTP.get_response(actualUri)

  # return actualResponse.body

  definitionUri = URI.parse("http://localhost:8090/api/definition")

  # Shortcut
  definitionResponse = Net::HTTP.get_response(definitionUri)

  return actualResponse.body << definitionResponse.body
end

