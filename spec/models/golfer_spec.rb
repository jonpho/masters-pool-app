require 'rails_helper'

RSpec.describe Golfer, type: :model do
  describe "primary key" do
    it "uses player_id as the primary key" do
      expect(Golfer.primary_key).to eq("player_id")
    end

    it "can be found by player_id" do
      golfer = Golfer.create!(name: "Tiger Woods", world_ranking: "1")
      expect(Golfer.find(golfer.player_id)).to eq(golfer)
    end
  end

  describe "associations" do
    describe "#leaderboards" do
      it "has many leaderboards" do
        association = Golfer.reflect_on_association(:leaderboards)
        expect(association.macro).to eq(:has_many)
      end

      it "can access associated leaderboards" do
        golfer = Golfer.create!(name: "Tiger Woods", world_ranking: "1")
        leaderboard = Leaderboard.create!(golfer_id: golfer.player_id, year: 2023, position: 1)

        expect(golfer.leaderboards).to include(leaderboard)
        expect(golfer.leaderboards.count).to eq(1)
      end

      it "can have multiple leaderboards for different years" do
        golfer = Golfer.create!(name: "Tiger Woods", world_ranking: "1")
        Leaderboard.create!(golfer_id: golfer.player_id, year: 2022, position: 5)
        Leaderboard.create!(golfer_id: golfer.player_id, year: 2023, position: 1)

        expect(golfer.leaderboards.count).to eq(2)
      end
    end

    describe "#flights" do
      it "has and belongs to many flights" do
        association = Golfer.reflect_on_association(:flights)
        expect(association.macro).to eq(:has_and_belongs_to_many)
      end

      it "can be assigned to multiple flights" do
        golfer = Golfer.create!(name: "Tiger Woods", world_ranking: "1")
        flight_a = Flight.create!(name: "Flight A")
        flight_b = Flight.create!(name: "Flight B")

        golfer.flights << flight_a
        golfer.flights << flight_b

        expect(golfer.flights.count).to eq(2)
        expect(golfer.flights).to include(flight_a, flight_b)
      end
    end
  end

  describe "attributes" do
    it "can be created with name and world_ranking" do
      golfer = Golfer.create!(name: "Rory McIlroy", world_ranking: "2")

      expect(golfer.name).to eq("Rory McIlroy")
      expect(golfer.world_ranking).to eq("2")
      expect(golfer.player_id).to be_present
    end
  end
end
