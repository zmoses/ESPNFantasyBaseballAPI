require_relative "../test_helper"

class ESPNApi::ClientTest < Minitest::Test
  def setup
    @client = ESPNApi::Client.new(
      auth_key: "test_auth_key",
      league_id: "12345",
      year: 2024
    )
  end

  def test_initializes_with_required_parameters
    client = ESPNApi::Client.new(auth_key: "key", league_id: "123")

    assert_instance_of ESPNApi::Client, client
  end

  def test_initializes_with_custom_year
    client = ESPNApi::Client.new(auth_key: "key", league_id: "123", year: 2023)

    assert_instance_of ESPNApi::Client, client
  end

  def test_get_request_includes_auth_cookie
    stub_request(:get, "https://lm-api-reads.fantasy.espn.com/test?")
      .with(headers: { "Cookie" => "espn_s2=test_auth_key" })
      .to_return(status: 200, body: '{"success": true}')

    response = @client.get("/test")

    assert_equal '{"success": true}', response
  end

  def test_get_request_encodes_query_params
    stub_request(:get, "https://lm-api-reads.fantasy.espn.com/test?view=mRoster&teamId=1")
      .to_return(status: 200, body: '{"data": []}')

    response = @client.get("/test", { view: "mRoster", teamId: 1 })

    assert_equal '{"data": []}', response
  end

  def test_get_request_includes_custom_headers
    stub_request(:get, "https://lm-api-reads.fantasy.espn.com/test?")
      .with(headers: { "X-Fantasy-Filter" => '{"players":{}}' })
      .to_return(status: 200, body: '{}')

    @client.get("/test", {}, { "X-Fantasy-Filter" => '{"players":{}}' })

    assert_requested :get, "https://lm-api-reads.fantasy.espn.com/test?",
      headers: { "X-Fantasy-Filter" => '{"players":{}}' }
  end

  def test_post_request_sends_json_body
    stub_request(:post, "https://lm-api-reads.fantasy.espn.com/test")
      .with(
        body: '{"key":"value"}',
        headers: {
          "Content-Type" => "application/json",
          "Cookie" => "espn_s2=test_auth_key"
        }
      )
      .to_return(status: 200, body: '{"created": true}')

    response = @client.post("/test", key: "value")

    assert_equal '{"created": true}', response
  end

  def test_put_request_sends_json_body
    stub_request(:put, "https://lm-api-reads.fantasy.espn.com/test")
      .with(
        body: '{"updated":"data"}',
        headers: {
          "Content-Type" => "application/json",
          "Cookie" => "espn_s2=test_auth_key"
        }
      )
      .to_return(status: 200, body: '{"updated": true}')

    response = @client.put("/test", updated: "data")

    assert_equal '{"updated": true}', response
  end

  def test_delete_request_sends_json_body
    stub_request(:delete, "https://lm-api-reads.fantasy.espn.com/test")
      .with(
        body: '{"id":123}',
        headers: {
          "Content-Type" => "application/json",
          "Cookie" => "espn_s2=test_auth_key"
        }
      )
      .to_return(status: 200, body: '{"deleted": true}')

    response = @client.delete("/test", id: 123)

    assert_equal '{"deleted": true}', response
  end

  def test_uses_ssl_for_all_requests
    stub_request(:get, "https://lm-api-reads.fantasy.espn.com/secure?")
      .to_return(status: 200, body: "{}")

    @client.get("/secure")

    assert_requested :get, %r{https://}
  end

  def test_base_url_is_correct
    assert_equal "https://lm-api-reads.fantasy.espn.com", ESPNApi::Client::BASE_URL
  end
end
