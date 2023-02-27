class Golfer < ApplicationRecord
  self.primary_key = "player_id"

  has_many :leaderboards

end
