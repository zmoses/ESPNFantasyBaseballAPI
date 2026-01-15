# Leagues Endpoints

These are all the parts of the API that utilize the following endpoint:
```/apis/v3/games/flb/seasons/<year>/segments/0/leagues/<league_id>```
This gem has split the calls into different methods, though all information through each method can be obtained through a single API call. Each different bit of data in each method has an associated "view" parameter. Each string representing each method is listed below. You can also grab any combination of views through a single bulk_view_request method call, as documented below.

### team_rosters
Params: team_id (optional)
Returns the roster for a specific manager if passed a team ID, or returns rosters for all managers if the team id is omitted. 

view parameter:  mRoster
response data returned: "teams"
structure:
[
  {
    "id": id of the team
    "roster": {
      "appliedStatTotal": ???,
      "entries": [
        {
          "acquisitionDate": Time player was acquired in milliseconds,
          "acquisitionType": One of ["DRAFT", TODO: other values],
          "injuryStatus": One of ["NORMAL", TODO: other values],
          "lineupSlotId": ????
        }
      ]
    }
  }
]

### draft_details
Returns information about the draft for the league.

view parameter:   mDraftDetail
response data returned: "draftDetail", "settings"

### current_matchup_info
Returns an array of matchups.
TODO: is this endpoint needed?

view parameter:  mLiveScoring
response data returned: "schedule"

### player_info
Returns a list of players filtered with the below header. Example player:
{"draftAuctionValue" => 0,
 "id" => 30417,
 "keeperValue" => 0,
 "keeperValueFuture" => 0,
 "lineupLocked" => false,
 "onTeamId" => 0,
 "player" =>
  {"active" => true,
   "defaultPositionId" => 11,
   "draftRanksByRankType" =>
    {"STANDARD" =>
      {"auctionValue" => 0,
       "published" => false,
       "rank" => 2620,
       "rankSourceId" => 0,
       "rankType" => "STANDARD",
       "slotId" => 0},
     "ROTO" =>
      {"auctionValue" => 0,
       "published" => false,
       "rank" => 2409,
       "rankSourceId" => 0,
       "rankType" => "ROTO",
       "slotId" => 0}},
   "droppable" => true,
   "eligibleSlots" => [13, 15, 16, 17],
   "firstName" => "Fernando",
   "fullName" => "Fernando Abad",
   "id" => 30417,
   "injured" => false,
   "injuryStatus" => "ACTIVE",
   "jersey" => "60",
   "lastName" => "Abad",
   "lastNewsDate" => 1692943890000,
   "ownership" =>
    {"activityLevel" => nil,
     "auctionValueAverage" => 0.0,
     "auctionValueAverageChange" => 0.0,
     "averageDraftPosition" => 260.0,
     "averageDraftPositionPercentChange" => 0.0,
     "date" => 1759118724386,
     "leagueType" => 0,
     "percentChange" => -0.0005175429663737598,
     "percentOwned" => 0.0026971262120210914,
     "percentStarted" => 0.0026971262120210914},
   "proTeamId" => 0,
   "stats" =>
    [{"appliedAverage" => 0.0,
      "appliedTotal" => 0.0,
      "externalId" => "2024",
      "id" => "002024",
      "proTeamId" => 0,
      "scoringPeriodId" => 0,
      "seasonId" => 2024,
      "statSourceId" => 0,
      "statSplitTypeId" => 0,
      "stats" => {}},
     {"appliedAverage" => 0.0,
      "appliedTotal" => 0.0,
      "externalId" => "2025",
      "id" => "002025",
      "proTeamId" => 0,
      "scoringPeriodId" => 0,
      "seasonId" => 2025,
      "statSourceId" => 0,
      "statSplitTypeId" => 0,
      "stats" => {}},
     {"appliedAverage" => 0.0,
      "appliedTotal" => 0.0,
      "externalId" => "2025",
      "id" => "012025",
      "proTeamId" => 0,
      "scoringPeriodId" => 0,
      "seasonId" => 2025,
      "statSourceId" => 0,
      "statSplitTypeId" => 1,
      "stats" => {}},
     {"appliedAverage" => 0.0,
      "appliedTotal" => 0.0,
      "externalId" => "2025",
      "id" => "032025",
      "proTeamId" => 0,
      "scoringPeriodId" => 0,
      "seasonId" => 2025,
      "statSourceId" => 0,
      "statSplitTypeId" => 3,
      "stats" => {}},
     {"appliedAverage" => 0.0,
      "appliedTotal" => 0.0,
      "externalId" => "2025",
      "id" => "022025",
      "proTeamId" => 0,
      "scoringPeriodId" => 0,
      "seasonId" => 2025,
      "statSourceId" => 0,
      "statSplitTypeId" => 2,
      "stats" => {}}]},
  "ratings" =>
    {"0" => {"positionalRanking" => 0, "totalRanking" => 0, "totalRating" => 0.0},
    "1" => {"positionalRanking" => 0, "totalRanking" => 0, "totalRating" => 0.0},
    "2" => {"positionalRanking" => 0, "totalRanking" => 0, "totalRating" => 0.0},
    "3" => {"positionalRanking" => 0, "totalRanking" => 0, "totalRating" => 0.0}},
  "rosterLocked" => false,
  "status" => "FREEAGENT",
  "tradeLocked" => false
}

Example X-Fantasy-Filter header pulled from the UI:
{
  players: {
    filterStatus: {
      value: [
        "FREEAGENT",
        "WAIVERS"
      ]
    },
    filterSlotIds: {
      value: [
        0,1,2,3,4,5,6,7,8,9,10,11,12,19
      ]
    },
    filterRanksForScoringPeriodIds: {
      value:[196]
    },
    limit:50,
    offset:50,
    sortPercOwned: {
      sortAsc:false,
      sortPriority:1
    },
    sortDraftRanks: {
      sortPriority:100,
      sortAsc:true,
      value:"STANDARD"
    },
    filterRanksForRankTypes: {
      value:["STANDARD"]
    },
    filterStatsForTopScoringPeriodIds: {
      value:5,
      additionalValue: ["002025","102025","002024","012025","022025","032025","042025","062025","010002025"]
    }
  }
}

### team_matchup_score

### pending_transactions

### league_settings
view parameter:  mSettings
response data returned: "settings"

### league_team_info
view parameter:  mTeam
response data returned: "members", "teams"

### modular
view parameter:  modular
response data returned: "draftDetail", "gameId", "id", "scoringPeriodId", "seasonId", "segmentId", "status"

### teams_info
view parameter:  mNav
response data returned: "teams", "members"

## Unused Views
### mPositionalRatings
I have no idea what this view is for. As an example, the mPendingTransactions view returns the same as this, except with the pendingTransactions key that's unique to this route. There doesn't seem to be anything unique in this view.

## bulk_view_request
TODO: fill this one in


