require_relative 'lib/espn_api'

def client
  @client ||= ESPNApi::Client.new(
    auth_key: ENV["ESPN_KEY"],
    league_id: ENV["LEAGUE_ID"],
    year: 2025
  )
end