# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'csv'

def create_flight_data
  flight_names = ["Group A", "Group B", "Group C", "Group D", "Group E"]
  flight_names.each do |flight_group|
    Flight.create(name: flight_group)
  end
  puts "Created #{flight_names.count} Flight Groups"
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
create_flight_data
Leaderboard.create(golfer_id: 1, year: 2023, position: 1, round_one: 69, round_two: 71, round_three: 70, round_four: 68, total: 278)
