require_relative "../test_helper"

class ESPNApi::FiltersTest < Minitest::Test
  def test_initializes_with_empty_filters
    filters = ESPNApi::Filters.new

    assert_equal({}, filters.to_h)
  end

  def test_initializes_with_single_filter
    player_filter = ESPNApi::Filters::Player.new
    filters = ESPNApi::Filters.new(player_filter)

    assert filters.to_h.key?(:players)
  end

  def test_merges_multiple_filters
    player_filter = ESPNApi::Filters::Player.new
    schedule_filter = ESPNApi::Filters::Schedule.new.current_matchup_only(true)

    filters = ESPNApi::Filters.new(player_filter, schedule_filter)

    assert filters.to_h.key?(:players)
    assert filters.to_h.key?(:schedule)
  end

  def test_to_h_returns_hash
    filters = ESPNApi::Filters.new

    assert_instance_of Hash, filters.to_h
  end

  def test_to_json_returns_json_string
    filters = ESPNApi::Filters.new

    assert_equal "{}", filters.to_json
  end

  def test_to_json_with_nested_data
    player_filter = ESPNApi::Filters::Player.new.limit(10)
    filters = ESPNApi::Filters.new(player_filter)

    json = filters.to_json
    parsed = JSON.parse(json)

    assert_equal 10, parsed["players"]["limit"]
  end

  def test_plus_operator_combines_filters
    filter1 = ESPNApi::Filters::Player.new
    filter2 = ESPNApi::Filters::Schedule.new.current_matchup_only(true)

    combined = filter1 + filter2

    assert_instance_of ESPNApi::Filters, combined
    assert combined.to_h.key?(:players)
    assert combined.to_h.key?(:schedule)
  end

  def test_plus_operator_returns_new_filter_instance
    filter1 = ESPNApi::Filters::Player.new
    filter2 = ESPNApi::Filters::Schedule.new

    combined = filter1 + filter2

    refute_same filter1, combined
    refute_same filter2, combined
  end

  def test_section_raises_not_implemented_error
    filter = ESPNApi::Filters.new

    assert_raises(NotImplementedError) do
      filter.send(:section)
    end
  end
end
