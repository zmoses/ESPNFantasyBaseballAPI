require_relative "../../test_helper"

class ESPNApi::Filters::ScheduleTest < Minitest::Test
  def setup
    @filter = ESPNApi::Filters::Schedule.new
  end

  def test_section_returns_schedule
    assert_equal :schedule, @filter.send(:section)
  end

  def test_current_matchup_only_true
    @filter.current_matchup_only(true)

    expected = { value: true }
    assert_equal expected, @filter.to_h[:schedule][:filterCurrentMatchupPeriod]
  end

  def test_current_matchup_only_false
    @filter.current_matchup_only(false)

    expected = { value: false }
    assert_equal expected, @filter.to_h[:schedule][:filterCurrentMatchupPeriod]
  end

  def test_returns_self_for_chaining
    result = @filter.current_matchup_only(true)

    assert_same @filter, result
  end

  def test_to_json_produces_valid_json
    @filter.current_matchup_only(true)

    json = @filter.to_json
    parsed = JSON.parse(json)

    assert_equal true, parsed["schedule"]["filterCurrentMatchupPeriod"]["value"]
  end

  def test_combines_with_player_filter
    player_filter = ESPNApi::Filters::Player.new.limit(10)
    combined = @filter.current_matchup_only(true) + player_filter

    assert combined.to_h.key?(:schedule)
    assert combined.to_h.key?(:players)
    assert_equal({ value: true }, combined.to_h[:schedule][:filterCurrentMatchupPeriod])
    assert_equal 10, combined.to_h[:players][:limit]
  end
end
