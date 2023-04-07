# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'csv'

def create_grouping_data
  flights = ["Group A", "Group B", "Group C", "Group D", "Group E"]
  flights.each do |flight_group|
    Grouping.create(flight: flight_group)
  end
end

def create_golfers
  pros_list = CSV.parse(File.read(Rails.root.join("db", "mastersPlayerRankings2013.csv")), headers: true)
  puts "Creating Golfers"
  puts "Pro Count #{pros_list.count}"

  pros_list.each do |pro_data|
    Golfer.create!(name: pro_data["player"], world_ranking: pro_data["ranking"])
  end
end

create_golfers
create_grouping_data
Leaderboard.create(golfer_id: 1, year: 2023, position: 1, round_one: 69, round_two: 71, round_three: 70, round_four: 68, total: 278)
