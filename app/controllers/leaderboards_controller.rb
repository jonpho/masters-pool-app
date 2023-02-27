class LeaderboardsController < ApplicationController
  protect_from_forgery with: :null_session

  def single_entry
    params.require([:golfer_id])
    golfer_id = params["golfer_id"]
    year = params["year"]
    position = params["position"]
    round_one = params["round_one"]
    round_two = params["round_two"]
    round_three = params["round_three"]
    round_four = params["round_four"]
    total = params["total"]
    earnings = params["earnings"]

    golfer_scorecard = Leaderboard.find_by(golfer_id: golfer_id, year: year)
    if golfer_scorecard.nil?
      begin
        Leaderboard.create!(golfer_id: golfer_id, year: year, position: position, round_one: round_one, round_two: round_two, round_three: round_three, round_four: round_four, total: total, earnings: earnings)
        render status: 200, json: { message: "Success" }
      rescue IOError => e
        render json: { message: "Failed" }
      end
    else
      begin
        golfer_scorecard.update!(position: position, round_one: round_one, round_two: round_two, round_three: round_three, round_four: round_four, total: total, earnings: earnings)
        render status: 200, json: { message: "Success" }
      rescue IOError => e
        render status: 400
      end
    end
  end

end
