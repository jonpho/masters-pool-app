class LeaderboardsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  def single_entry
    data = {
      golfer_id: params["golfer_id"],
      year: params["year"],
      position: params["position"],
      round_one: params["round_one"],
      round_two: params["round_two"],
      round_three: params["round_three"],
      round_four: params["round_four"],
      total: params["total"],
      earnings: params["earnings"]
    }

    golfer_scorecard = Leaderboard.find_by(golfer_id: data[:golfer_id], year: data[:year])
    golfer_scorecard.nil? ? leaderboard_entry(data) : update_leaderboard_entry(golfer_scorecard, data)
  end

  def index
    @leaderboards = Leaderboard.all
  end

  private

  def leaderboard_entry(golfer_data)
    Leaderboard.create!(golfer_id: golfer_data[:golfer_id],
      year: golfer_data[:year],
      position: golfer_data[:position],
      round_one: golfer_data[:round_one],
      round_two: golfer_data[:round_two],
      round_three: golfer_data[:round_three],
      round_four: golfer_data[:round_four],
      total: golfer_data[:total],
      earnings: golfer_data[:earnings])
    render status: 200, json: {message: "Success"}
  rescue ActiveRecord::RecordInvalid => e
    render status: 422, json: {message: e}
  end

  def update_leaderboard_entry(golfer_data, entry_data)
    entry_data = entry_data.except(:golfer_id, :year).compact
    entry_data.each do |key, value|
      golfer_data[key] = value
    end
    golfer_data.save!
    render status: 200, json: {message: "Success"}
  rescue ActiveRecord::RecordInvalid => e
    render status: 422, json: {message: e}
  end
end
