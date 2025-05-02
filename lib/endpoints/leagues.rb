module Leagues
  def team_rosters(team_id = nil)
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    params = { view: "mRoster" }
    params[:rosterForTeamId] = team_id if team_id
    response = JSON.parse(get(endpoint, **params))

    team_id ? response["teams"].select{ |team| team["id"] == team_id }.first : response["teams"]
  end

  def draft_details
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, view: "mDraftDetail")).slice("draftDetail", "settings")
  end

  def current_matchup_info
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, view: "mLiveScoring"))["schedule"]
  end

  def matchup_scores
    # Returns an array of hashes with the following keys for each matchup period:
    # ["away", "home", "id", "matchupPeriodId", "playoffTierType", "winner"]
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    response = JSON.parse(get(endpoint,  view: "mMatchupScore"))["schedule"]
  end

  def pending_transactions
    # Ex.
    # [{"bidAmount"=>0,
    # "executionType"=>"EXECUTE",
    # "expirationDate"=>1746047126443,
    # "id"=>"73f97956-3963-4a77-b96e-0067e6b549a4",
    # "isActingAsTeamOwner"=>false,
    # "isLeagueManager"=>false,
    # "isPending"=>true,
    # "items"=>
    # [{"fromLineupSlotId"=>0, "fromTeamId"=>1, "isKeeper"=>false, "overallPickNumber"=>0, "playerId"=>4781491, "toLineupSlotId"=>-1, "toTeamId"=>3, "type"=>"TRADE"},
    #   {"fromLineupSlotId"=>4, "fromTeamId"=>3, "isKeeper"=>false, "overallPickNumber"=>0, "playerId"=>42403, "toLineupSlotId"=>-1, "toTeamId"=>1, "type"=>"TRADE"}],
    # "memberId"=>"{9E81B1DB-5C2B-41C6-88CC-41D9B03F0323}",
    # "proposedDate"=>1745874326364,
    # "rating"=>0,
    # "scoringPeriodId"=>42,
    # "status"=>"PENDING",
    # "teamActions"=>{"1"=>"ACCEPTED"},
    # "teamId"=>1,
    # "type"=>"TRADE_PROPOSAL"}]

    # {"bidAmount"=>0,
    # "executionType"=>"EXECUTE",
    # "id"=>"94108918-3d2f-4f08-80c5-018ee8cf03ba",
    # "isActingAsTeamOwner"=>false,
    # "isLeagueManager"=>false,
    # "isPending"=>true,
    # "items"=>
    #   [{"fromLineupSlotId"=>-1, "fromTeamId"=>0, "isKeeper"=>false, "overallPickNumber"=>0, "playerId"=>4781491, "toLineupSlotId"=>-1, "toTeamId"=>1, "type"=>"ADD"},
    #   {"fromLineupSlotId"=>16, "fromTeamId"=>1, "isKeeper"=>false, "overallPickNumber"=>0, "playerId"=>33712, "toLineupSlotId"=>-1, "toTeamId"=>0, "type"=>"DROP"}],
    # "memberId"=>"{9E81B1DB-5C2B-41C6-88CC-41D9B03F0323}",
    # "processDate"=>1745996400000,
    # "proposedDate"=>1745875038472,
    # "rating"=>0,
    # "scoringPeriodId"=>42,
    # "status"=>"PENDING",
    # "teamId"=>1,
    # "type"=>"WAIVER"}

    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    response = JSON.parse(get(endpoint,  view: "mPendingTransactions"))

    # response["pendingTransactions"] || []
  end

  def league_settings
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint,  view: "mSettings"))["settings"]
  end

  def league_team_info
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, view: "mTeam")).slice("members", "teams")
  end

  def modular
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    JSON.parse(get(endpoint, view: "modular"))
  end

  def teams_info
    endpoint = "/apis/v3/games/flb/seasons/#{@year}/segments/0/leagues/#{@league_id}"
    response = JSON.parse(get(endpoint, view: "mNav"))
    response["teams"].each do |team|
      owners_info = []
      team["owners"].each do |owner_id|
        owners_info << response["members"].select { |member| member["id"] == owner_id }.first
      end
      team["owners"] = owners_info
    end
    response["teams"]
  end

  def league_basic_info(team_id = nil)
    # The following keys are returned in all "views" and are ignored in other responses:
    # gameId, id, scoringPeriodId, seasonId, segmentId

    # Note, the draftDetail key is also included in all views, except this one for some reason. In most views, it has
    # a hash with two values for whether the draft is in progress and if it's done. In the mDraftDetail view, it's
    # got these plus a bunch more info. Therefore, in other views this key is also ignored.

    # The status key is also returned in all views, but is much less detailed without a view specified. TODO: Decide
    # what to do with this key.

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