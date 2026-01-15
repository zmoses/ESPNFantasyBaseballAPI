require_relative "../../test_helper"

class ESPNApi::Filters::PlayerTest < Minitest::Test
  def setup
    @filter = ESPNApi::Filters::Player.new
  end

  def test_initializes_with_default_limit
    assert_equal 50, @filter.to_h[:players][:limit]
  end

  def test_initializes_with_default_sort_by_draft_rank
    sort = @filter.to_h[:players][:sortDraftRanks]

    assert_equal true, sort[:sortAsc]
    assert_equal 100, sort[:sortPriority]
    assert_equal "STANDARD", sort[:value]
  end

  def test_section_returns_players
    assert_equal :players, @filter.send(:section)
  end

  # Status filter tests
  def test_status_with_single_symbol
    @filter.status(:free_agent)

    assert_equal({ value: ["FREEAGENT"] }, @filter.to_h[:players][:filterStatus])
  end

  def test_status_with_multiple_symbols
    @filter.status(:free_agent, :waivers)

    expected = { value: ["FREEAGENT", "WAIVERS"] }
    assert_equal expected, @filter.to_h[:players][:filterStatus]
  end

  def test_status_with_all_known_statuses
    @filter.status(:free_agent, :waivers, :on_team)

    expected = { value: ["FREEAGENT", "WAIVERS", "ONTEAM"] }
    assert_equal expected, @filter.to_h[:players][:filterStatus]
  end

  def test_status_with_unknown_symbol_converts_to_uppercase
    @filter.status(:custom_status)

    assert_equal({ value: ["CUSTOM_STATUS"] }, @filter.to_h[:players][:filterStatus])
  end

  def test_status_values_constant
    expected = {
      free_agent: "FREEAGENT",
      waivers: "WAIVERS",
      on_team: "ONTEAM"
    }
    assert_equal expected, ESPNApi::Filters::Player::STATUS_VALUES
  end

  # Slot IDs filter tests
  def test_slot_ids_with_numeric_ids
    @filter.slot_ids(0, 1, 2)

    assert_equal({ value: [0, 1, 2] }, @filter.to_h[:players][:filterSlotIds])
  end

  def test_slot_ids_with_symbols
    @filter.slot_ids(:catcher, :first_base)

    assert_equal({ value: [0, 1] }, @filter.to_h[:players][:filterSlotIds])
  end

  def test_slot_ids_with_mixed_symbols_and_numbers
    @filter.slot_ids(:catcher, 5, :pitcher)

    assert_equal({ value: [0, 5, 10] }, @filter.to_h[:players][:filterSlotIds])
  end

  def test_slot_ids_constant_has_all_positions
    expected_positions = [
      :catcher, :first_base, :second_base, :third_base, :shortstop,
      :left_field, :center_field, :right_field, :designated_hitter,
      :utility, :pitcher, :starting_pitcher, :relief_pitcher,
      :bench, :injured_list, :injured_reserve, :minor_league, :outfield
    ]

    expected_positions.each do |position|
      assert ESPNApi::Filters::Player::SLOT_IDS.key?(position), "Expected SLOT_IDS to include #{position}"
    end
  end

  def test_all_positions
    @filter.all_positions

    slot_values = @filter.to_h[:players][:filterSlotIds][:value]

    ESPNApi::Filters::Player::SLOT_IDS.values.each do |id|
      assert_includes slot_values, id
    end
  end

  # Scoring period tests
  def test_scoring_period_ids
    @filter.scoring_period_ids(1, 2, 3)

    expected = { value: [1, 2, 3] }
    assert_equal expected, @filter.to_h[:players][:filterRanksForScoringPeriodIds]
  end

  # Rank types tests
  def test_rank_types_converts_to_uppercase
    @filter.rank_types(:ppr, :standard)

    expected = { value: ["PPR", "STANDARD"] }
    assert_equal expected, @filter.to_h[:players][:filterRanksForRankTypes]
  end

  # Stats for scoring periods tests
  def test_stats_for_scoring_periods
    @filter.stats_for_scoring_periods(5, 1, 2, 3)

    expected = { value: 5, additionalValue: [1, 2, 3] }
    assert_equal expected, @filter.to_h[:players][:filterStatsForTopScoringPeriodIds]
  end

  # Limit and offset tests
  def test_limit_overrides_default
    @filter.limit(100)

    assert_equal 100, @filter.to_h[:players][:limit]
  end

  def test_offset
    @filter.offset(50)

    assert_equal 50, @filter.to_h[:players][:offset]
  end

  # Sort tests
  def test_sort_by_percent_owned
    @filter.sort_by_percent_owned

    sort = @filter.to_h[:players][:sortPercOwned]

    assert_equal false, sort[:sortAsc]
    assert_equal 1, sort[:sortPriority]
    refute sort.key?(:value)
  end

  def test_sort_by_percent_owned_ascending
    @filter.sort_by_percent_owned(ascending: true, priority: 2)

    sort = @filter.to_h[:players][:sortPercOwned]

    assert_equal true, sort[:sortAsc]
    assert_equal 2, sort[:sortPriority]
  end

  def test_sort_by_draft_rank_custom
    @filter.sort_by_draft_rank(ascending: false, priority: 1, value: "PPR")

    sort = @filter.to_h[:players][:sortDraftRanks]

    assert_equal false, sort[:sortAsc]
    assert_equal 1, sort[:sortPriority]
    assert_equal "PPR", sort[:value]
  end

  # Method chaining tests
  def test_methods_return_self_for_chaining
    result = @filter.status(:free_agent)
      .slot_ids(:pitcher)
      .limit(25)
      .offset(10)

    assert_same @filter, result
  end

  def test_complex_filter_chain
    @filter.status(:free_agent, :waivers)
      .slot_ids(:starting_pitcher, :relief_pitcher)
      .limit(100)
      .offset(0)
      .sort_by_percent_owned(ascending: false, priority: 1)

    filters = @filter.to_h[:players]

    assert_equal({ value: ["FREEAGENT", "WAIVERS"] }, filters[:filterStatus])
    assert_equal({ value: [11, 12] }, filters[:filterSlotIds])
    assert_equal 100, filters[:limit]
    assert_equal 0, filters[:offset]
    assert_equal({ sortAsc: false, sortPriority: 1 }, filters[:sortPercOwned])
  end

  # JSON serialization
  def test_to_json_produces_valid_json
    @filter.status(:free_agent).limit(10)

    json = @filter.to_json
    parsed = JSON.parse(json)

    assert_equal 10, parsed["players"]["limit"]
    assert_equal ["FREEAGENT"], parsed["players"]["filterStatus"]["value"]
  end
end
