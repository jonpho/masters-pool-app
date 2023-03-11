# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
def create_grouping_data
  flights = ["Group A", "Group B", "Group C", "Group D", "Group E"]
  flights.each do |flight_group|
    Grouping.create(flight: flight_group)
  end
end

Golfer.create(firstname: "Tiger", lastname: "Woods", tour: "PGA", status: "Pro")
create_grouping_data
