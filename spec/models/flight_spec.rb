require 'rails_helper'

RSpec.describe Flight, type: :model do
  describe "associations" do
    describe "#golfers" do
      it "has and belongs to many golfers" do
        association = Flight.reflect_on_association(:golfers)
        expect(association.macro).to eq(:has_and_belongs_to_many)
      end

      it "can have multiple golfers" do
        flight = Flight.create!(name: "Flight A")
        golfer1 = Golfer.create!(name: "Tiger Woods", world_ranking: "1")
        golfer2 = Golfer.create!(name: "Rory McIlroy", world_ranking: "2")

        flight.golfers << golfer1
        flight.golfers << golfer2

        expect(flight.golfers.count).to eq(2)
        expect(flight.golfers).to include(golfer1, golfer2)
      end

      it "golfers can access their flights" do
        flight = Flight.create!(name: "Flight A")
        golfer = Golfer.create!(name: "Tiger Woods", world_ranking: "1")

        flight.golfers << golfer

        expect(golfer.flights).to include(flight)
      end
    end
  end

  describe "attributes" do
    it "can be created with a name" do
      flight = Flight.create!(name: "Flight A")

      expect(flight.name).to eq("Flight A")
      expect(flight).to be_persisted
    end
  end

  describe "flight groupings" do
    it "supports organizing golfers by ranking tiers" do
      flight_a = Flight.create!(name: "Flight A - Top Ranked")
      flight_b = Flight.create!(name: "Flight B - Mid Ranked")

      top_golfer = Golfer.create!(name: "Scottie Scheffler", world_ranking: "1")
      mid_golfer = Golfer.create!(name: "Mid Tier Player", world_ranking: "50")

      flight_a.golfers << top_golfer
      flight_b.golfers << mid_golfer

      expect(flight_a.golfers).to include(top_golfer)
      expect(flight_b.golfers).to include(mid_golfer)
      expect(flight_a.golfers).not_to include(mid_golfer)
    end
  end
end
