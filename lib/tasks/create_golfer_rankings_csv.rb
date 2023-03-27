require 'csv'

pros = CSV.parse(File.read("Masters2023Pros.csv"), headers: true)
amateurs = CSV.parse(File.read("Masters2023Amateurs.csv"), headers: true)
rankings = CSV.parse(File.read("golf_world_rankings_list.csv"), headers: true)

header = ["player", "ranking"]
CSV.open("masters_players_rankings.csv", "wb") do |csv|
  csv << header
  pros.each do |pro|
    splitter = pro["INVITEES"].split(",")
    pro["INVITEES"] = "#{splitter[1]} #{splitter[0]}".strip
    rank_info = rankings.find { |row| row["NAME"] == pro["INVITEES"] }
    row_data = rank_info.nil? ? [pro["INVITEES"], "Unranked"] : [pro["INVITEES"], rank_info["RK"]]
    csv << row_data
  end

  amateurs.each do |amateur|
    splitter = amateur["INVITEES"].split(",")
    amateur["INVITEES"] = "#{splitter[1]} #{splitter[0]}".strip
    row_data = [amateur["INVITEES"], "Amateur"]
    csv << row_data
  end
end
