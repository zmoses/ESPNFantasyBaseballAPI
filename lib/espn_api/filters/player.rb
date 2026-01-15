module ESPNApi
  class Filters
    class Player < Filters
      STATUS_VALUES = {
        free_agent: "FREEAGENT",
        waivers: "WAIVERS",
        on_team: "ONTEAM"
      }.freeze

      SLOT_IDS = {
        catcher: 0,
        first_base: 1,
        second_base: 2,
        third_base: 3,
        shortstop: 4,
        left_field: 5,
        center_field: 6,
        right_field: 7,
        designated_hitter: 8,
        utility: 9,
        pitcher: 10,
        starting_pitcher: 11,
        relief_pitcher: 12,
        bench: 13,
        injured_list: 14,
        injured_reserve: 15,
        minor_league: 16,
        outfield: 19
      }.freeze

      def status(*statuses)
        values = statuses.map { |s| STATUS_VALUES[s] || s.to_s.upcase }
        add_filter(:filterStatus, { value: values })
      end

      def slot_ids(*ids)
        resolved_ids = ids.map { |id| id.is_a?(Symbol) ? SLOT_IDS[id] : id }
        add_filter(:filterSlotIds, { value: resolved_ids })
      end

      def all_positions
        slot_ids(*SLOT_IDS.values)
      end

      def scoring_period_ids(*ids)
        add_filter(:filterRanksForScoringPeriodIds, { value: ids })
      end

      def rank_types(*types)
        values = types.map { |t| t.to_s.upcase }
        add_filter(:filterRanksForRankTypes, { value: values })
      end

      def stats_for_scoring_periods(top_count, *period_ids)
        add_filter(:filterStatsForTopScoringPeriodIds, {
          value: top_count,
          additionalValue: period_ids
        })
      end

      def limit(n)
        add_filter(:limit, n)
      end

      def offset(n)
        add_filter(:offset, n)
      end

      def sort_by_percent_owned(ascending: false, priority: 1)
        add_sort(:sortPercOwned, ascending: ascending, priority: priority)
      end

      def sort_by_draft_rank(ascending: true, priority: 100, value: "STANDARD")
        add_sort(:sortDraftRanks, ascending: ascending, priority: priority, value: value)
      end

      protected

      def section
        :players
      end
    end
  end
end
