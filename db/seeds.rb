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

def create_golfers
  pros = ["Ancer, Abraham", "Bradley, Keegan", "Burns, Sam", "Cantlay, Patrick", "Champ, Cameron", "Conners, Corey", "Couples, Fred", "DeChambeau, Bryson", "Finau, Tony", "Fitzpatrick, Matt", "Fleetwood, Tommy", "Fox, Ryan", "Garcia, Sergio", "Gooch, Talor", "Harman, Brian", "Hatton, Tyrrell", "Henley, Russell", "Higa, Kazuki", "Hoge, Tom", "Homa, Max", "Horschel, Billy", "Hovland, Viktor", "Hughes, Mackenzie", "Im, Sungjae", "Johnson, Dustin", "Johnson, Zach", "Kim, Si Woo", "Kim, Tom", "Kirk, Chris", "Kisner, Kevin", "Kitayama, Kurt", "Koepka, Brooks", "Kokrak, Jason", "Langer, Bernhard", "Lee, Kyoung-Hoon", "Lowry, Shane", "Lyle, Sandy", "Matsuyama, Hideki", "McIlroy, Rory", "Meronk, Adrian", "Mickelson, Phil", "Mize, Larry", "Molinari, Francesco", "Moore, Taylor", "Morikawa, Collin", "Na, Kevin", "Niemann, Joaquin", "Noren, Alex", "Olazabal, Jose Maria", "Oosthuizen, Louis", "Pereira, Mito", "Pieters, Thomas", "Poston, J.T.", "Power, Seamus", "Rahm, Jon", "Reed, Patrick", "Rose, Justin", "Schauffele, Xander", "Scheffler, Scottie", "Schwartzel, Charl", "Scott, Adam", "Singh, Vijay", "Smith, Cameron", "Spieth, Jordan", "Stallings, Scott", "Straka, Sepp", "Svensson, Adam", "Theegala, Sahith", "Thomas, Justin", "Varner III, Harold", "Watson, Bubba", "Weir, Mike", "Willett, Danny", "Wise, Aaron", "Woodland, Gary", "Woods, Tiger", "Young, Cameron", "Zalatoris, Will"]
  amateurs = ["Bennett, Sam", "Carr, Ben", "Crowe, Harrison", "Fernandez de Oliveira, Mateo", "McClean, Matthew", "Potgieter, Aldrich", "Sargent, Gordon"]

  pros.each do |pro|
    Golfer.create!(name: pro, tour: "PGA", status: "Pro")
  end

  amateurs.each do |amateur|
    Golfer.create!(name: amateur, status: "Amateur")
  end
end

create_golfers
create_grouping_data
Leaderboard.create(golfer_id: 1, year: 2023, position: 1, round_one: 69, round_two: 71, round_three: 70, round_four: 68, total: 278)
