class UserSubmission < ApplicationRecord
  belongs_to :golfer, primary_key: "player_id"
  belongs_to :user
end
