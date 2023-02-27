class Leaderboard < ApplicationRecord
  belongs_to :golfer, primary_key: "player_id"
end
