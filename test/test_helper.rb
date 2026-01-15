require "minitest/autorun"
require "webmock/minitest"
require_relative "../lib/espn_api"

# Disable external connections during tests
WebMock.disable_net_connect!
