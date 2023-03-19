class GroupAssignment < ApplicationRecord
  belongs_to :golfer, primary_key: "player_id"
  belongs_to :grouping
end
