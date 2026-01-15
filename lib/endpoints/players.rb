module Players
  private

  def players_endpoint
    "/apis/v3/games/flb/seasons/#{@year}/players"
  end
end