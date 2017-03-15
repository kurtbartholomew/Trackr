require 'httparty'

token = "49537cacbe0516712ab8aeb15f9c6e14"
url = "http://localhost:3000/api/projects/8/tickets/5.json"

response = HTTParty.get(url,
  headers: {
    "Authorization" => "Token token=#{token}"
  }
)

puts response.parsed_response
