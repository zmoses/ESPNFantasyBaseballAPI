# Leagues Endpoints

These are all the parts of the API that utilize the following endpoint:
```/apis/v3/games/flb/seasons/<year>/segments/0/leagues/<league_id>```
This gem has split the calls into different methods, though all information through each method can be obtained through a single API call. Each different bit of data in each method has an associated "view" parameter. Each string representing each method is listed below. You can also grab any combination of views through a single bulk_view_request method call, as documented below.

### team_rosters
Returns the roster for a specific manager if passed a team ID, or returns rosters for all managers if the team id is omitted. 

view parameter:  mRoster
info resides in: "teams"

### draft_details
Returns information about the draft for the league.

view parameter:   mDraftDetail
info resides in: "draftDetail", "settings"

### current_matchup_info
Returns an array of matchups.
TODO: is this endpoint needed?

view parameter:  mLiveScoring
info resides in: "schedule"

### team_matchup_score

### pending_transactions

### league_settings
view parameter:  mSettings
info resides in: "settings"

### league_team_info
view parameter:  mTeam
info resides in: "members", "teams"

### modular
view parameter:  modular
info resides in: "draftDetail", "gameId", "id", "scoringPeriodId", "seasonId", "segmentId", "status"

### teams_info
view parameter:  mNav
info resides in: "teams", "members"

## Unused Views
### mPositionalRatings
I have no idea what this view is for. As an example, the mPendingTransactions view returns the same as this, except with the pendingTransactions key that's unique to this route. There doesn't seem to be anything unique in this view.

## bulk_view_request
TODO: fill this one in


