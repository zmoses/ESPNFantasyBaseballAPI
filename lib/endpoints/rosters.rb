module Rosters
  # DONE
  def team_rosters(team_id = nil)
    # TODO: Documentation in comments

    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    params = { view: "mRoster" }
    params[:rosterForTeamId] = team_id if team_id
    response = JSON.parse(get(endpoint, **params))

    team_id ? response["teams"].select{ |team| team["id"] == team_id }.first : response["teams"]
  end

  def draft_details
    # TODO: Documentation in comments

    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, view: "mDraftDetail")).slice("draftDetail", "settings", "status")
  end

  def current_matchup_info
    # Returned keys:
    # draftDetail - A hash with two bool values for whether the draft it in progress and done
    # schedule - An array of hashes listing all matchup period IDs for the season
    # status - A hash with some info on the league and info about the current matchup and scoring period

    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, view: "mLiveScoring")).slice("draftDetail", "schedule", "status")
  end


  # TODO: Check what these return and shtuff

  def team_matchup_score(team_id)
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, rosterForTeamId: team_id, view: "mMatchupScore"))
  end

  def team_pending_transactions(team_id)
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, rosterForTeamId: team_id, view: "mPendingTransactions"))
  end

  def team_positional_ratings(team_id)
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, rosterForTeamId: team_id, view: "mPositionalRatings"))
  end

  def team_settings(team_id)
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, rosterForTeamId: team_id, view: "mSettings"))
  end

  # ?????????????????????????

  def team_team(team_id)
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, rosterForTeamId: team_id, view: "mTeam"))
  end

  def team_modular(team_id)
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, rosterForTeamId: team_id, view: "modular"))
  end

  def team_nav(team_id)
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, rosterForTeamId: team_id, view: "mNav"))
  end

  def league_basic_info(team_id)
    # The following keys are returned in all "views" and are ignored in other responses:
    # gameId - Always included, not relevant
    # id - Always included, not relevant
    # scoringPeriodId - Always included, not relevant
    # seasonId - Always included, not relevant
    # segmentId - Always included, not relevant

    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, rosterForTeamId: team_id))
  end

  def bulk_view_request(team_id: nil, views: [])
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    params = { view: views }
    params[:rosterForTeamId] = team_id if team_id
    JSON.parse(get(endpoint, rosterForTeamId: team_id))
  end
end