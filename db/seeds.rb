# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'csv'

def create_flight_data
  flight_names = ["Group A", "Group B", "Group C", "Group D", "Group E", "Group F"]
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

def create_flight_groups
  Golfer.all.collect do |golfer|
    compare = golfer.world_ranking
    
    if compare == "Unranked"
      golfer.flight_ids = 5
      next
    elsif compare == "Amateur"
      golfer.flight_ids = 6
      next
    else
      compare = golfer.world_ranking.to_i
    end

    if compare <= 10
      golfer.flight_ids = 1
    elsif compare > 10 && compare <= 27
      golfer.flight_ids = 2
    elsif compare > 27 && compare <= 49
      golfer.flight_ids = 3
    elsif compare > 49 && compare <= 106
      golfer.flight_ids = 4
    elsif compare >= 123 && compare <= 200
      golfer.flight_ids = 5
    else
      golfer.flight_is = 6
    end
  end
end

create_golfers
create_flight_data
create_flight_groups
Leaderboard.create(golfer_id: 1, year: 2023, position: 1, round_one: 69, round_two: 71, round_three: 70, round_four: 68, total: 278)
