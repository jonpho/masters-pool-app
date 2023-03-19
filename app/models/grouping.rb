class Grouping < ApplicationRecord
  has_many :group_assignments
  has_and_belongs_to_many :golfers
end
