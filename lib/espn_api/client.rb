require_relative "endpoints"
require "net/http"
require "json"

module ESPNApi
  class Client
    include ESPNApi::Endpoints

    BASE_URL = "https://lm-api-reads.fantasy.espn.com".freeze

    def initialize(auth_key:, league_id:, year: Time.now.year)
      @auth_key = auth_key
      @league_id = league_id
      @year = year
    end

    def get(endpoint, params = {}, headers = {})
      uri = URI("#{BASE_URL}#{endpoint}")
      uri.query = URI.encode_www_form(params)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
      headers.each { |key, value| request[key] = value }
      request["Cookie"] = "espn_s2=#{@auth_key}"
      response = http.request(request)
      response.body
    end

    def post(endpoint, **body)
      uri = URI("#{BASE_URL}#{endpoint}")

      request = Net::HTTP::Post.new(uri)
      request.body = body.to_json
      request["Content-Type"] = "application/json"
      request["Cookie"] = "espn_s2=#{@auth_key}"

      perform_request(uri, request).body
    end

    def put(endpoint, **body)
      uri = URI("#{BASE_URL}#{endpoint}")

      request = Net::HTTP::Put.new(uri)
      request.body = body.to_json
      request["Content-Type"] = "application/json"
      request["Cookie"] = "espn_s2=#{@auth_key}"

      perform_request(uri, request).body
    end

    def delete(endpoint, **body)
      uri = URI("#{BASE_URL}#{endpoint}")

      request = Net::HTTP::Delete.new(uri)
      request.body = body.to_json
      request["Content-Type"] = "application/json"
      request["Cookie"] = "espn_s2=#{@auth_key}"

      perform_request(uri, request).body
    end

    private

    def perform_request(uri, request)
      Net::HTTP.start(uri.hostname, uri.port,
                      use_ssl: true,
                      verify_mode: OpenSSL::SSL::VERIFY_PEER,
                      cert_store: build_cert_store) { |http|
        http.request(request)
      }
    end

    def build_cert_store
      cert_store = OpenSSL::X509::Store.new
      cert_store.set_default_paths
      # Don't set any CRL checking flags - this allows cert validation without requiring CRL
      cert_store
    end
  end
end
