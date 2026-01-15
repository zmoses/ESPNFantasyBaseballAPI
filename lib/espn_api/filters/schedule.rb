module ESPNApi
  class Filters
    class Schedule < Filters
      def current_matchup_only(only_show_current_matchup)
        add_filter(:filterCurrentMatchupPeriod, { value: only_show_current_matchup })
      end

      protected

      def section
        :schedule
      end
    end
  end
end
