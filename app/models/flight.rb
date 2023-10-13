class Flight < ApplicationRecord
  has_and_belongs_to_many :golfers
end