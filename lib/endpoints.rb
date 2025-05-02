require_relative "endpoints/leagues"
require_relative "endpoints/players"

module Endpoints
  include Leagues
  include Players
end
