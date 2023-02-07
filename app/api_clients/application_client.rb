require "net/http"

class ApplicationClient
  attr_reader :token

  def initialize(token:)
    @token = token
  end

  private

  def base_uri
    self.class::BASE_URI
  end

  def get(path, query: {})
    make_request Net::HTTP::Get, path, query: query
  end

  def post(path, query: {}, body: {})
    make_request Net::HTTP::Post, path, query: query, body: body
  end

  def patch(path, query: {}, body: {})
    make_request Net::HTTP::Patch, path, query: query, body: body
  end

  def put(path, query: {}, body: {})
    make_request Net::HTTP::Put, path, query: query, body: body
  end

  def delete(path, query: {})
    make_request Net::HTTP::Delete, path, query: query
  end

  def default_headers
    {
      "Authorization" => "Bearer #{token}",
      "Accept" => "application/json",
    }
  end

  def make_request(klass, path, query: {}, headers: {}, body: {})
    uri = URI("#{base_uri}#{path}")
    uri.query = Rack::Utils.build_query(query) if query

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.instance_of?(URI::HTTPS)

    request = klass.new(uri.request_uri, default_headers)
    if body.present?
      request.body = body.to_json
      request["Content-Type"] = "application/json"
    end

    response = http.request(request)
    case response.code
    when "200", "201", "202", "203", "204"
      JSON.parse(response.body) if response.body.present?
    else
      raise Error, response.body
    end
  end

  class Error < StandardError; end
end
