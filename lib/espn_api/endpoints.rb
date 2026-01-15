require_relative "endpoints/leagues"
require_relative "endpoints/players"

module ESPNApi
  module Endpoints
    include Leagues
    include Players
  end
end
