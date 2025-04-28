require_relative "../endpoints"
require "net/http"
require "json"

module ESPNApi
  class Client
    include Endpoints

    @@base_url = "https://lm-api-reads.fantasy.espn.com".freeze

    def initialize(auth_key:, league_id:, year: Time.now.year)
      @auth_key = auth_key
      @league_id = league_id
      @year = year
    end

    def self.test_init
      self.new(auth_key: ENV["ESPN_KEY"], league_id: ENV["LEAGUE_ID"])
    end

    private

    def get(endpoint, **params)
      uri = URI("#{@@base_url}#{endpoint}")
      uri.query = URI.encode_www_form(params)
      request = Net::HTTP::Get.new(uri)
      request["Cookie"] = "espn_s2=#{@auth_key};"

      perform_request(uri, request).body
    end

    def post(endpoint, **body)
      uri = URI("#{@@base_url}#{endpoint}")

      request = Net::HTTP::Post.new(uri)
      request.body = body.to_json
      request["Content-Type"] = "application/json"
      request["Cookie"] = "espn_s2=#{@auth_key}"

      perform_request(uri, request).body
    end

    def put(endpoint, **body)
      uri = URI("#{@@base_url}#{endpoint}")

      request = Net::HTTP::Put.new(uri)
      request.body = body.to_json
      request["Content-Type"] = "application/json"
      request["Cookie"] = "espn_s2=#{@auth_key}"

      perform_request(uri, request).body
    end

    def delete(endpoint, **body)
      uri = URI("#{@@base_url}#{endpoint}")

      request = Net::HTTP::Delete.new(uri)
      request.body = body.to_json
      request["Content-Type"] = "application/json"
      request["Cookie"] = "espn_s2=#{@auth_key}"

      perform_request(uri, request).body
    end

    private

    def perform_request(uri, request)
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http|
        http.request(request)
      }
    end
  end
end
