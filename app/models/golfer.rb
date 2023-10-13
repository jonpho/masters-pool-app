class Golfer < ApplicationRecord
  self.primary_key = "player_id"

  has_many :leaderboards
  has_and_belongs_to_many :groupings
  has_and_belongs_to_many :flights
  # has_and_belongs_to_many :user_submissions
end
