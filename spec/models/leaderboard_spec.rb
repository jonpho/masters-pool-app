require 'rails_helper'

RSpec.describe Leaderboard, type: :model do
  let(:golfer) { Golfer.create!(name: "Tiger Woods", world_ranking: "1") }

  describe "associations" do
    describe "#golfer" do
      it "belongs to golfer with custom primary key" do
        association = Leaderboard.reflect_on_association(:golfer)
        expect(association.macro).to eq(:belongs_to)
        expect(association.options[:primary_key]).to eq("player_id")
      end

      it "can access the associated golfer" do
        leaderboard = Leaderboard.create!(golfer_id: golfer.player_id, year: 2023)

        expect(leaderboard.golfer).to eq(golfer)
        expect(leaderboard.golfer.name).to eq("Tiger Woods")
      end

      it "correctly references golfer using player_id" do
        leaderboard = Leaderboard.create!(golfer_id: golfer.player_id, year: 2023)

        expect(leaderboard.golfer_id).to eq(golfer.player_id)
      end
    end
  end

  describe "attributes" do
    it "can store tournament round scores" do
      leaderboard = Leaderboard.create!(
        golfer_id: golfer.player_id,
        year: 2023,
        position: 1,
        round_one: 68,
        round_two: 70,
        round_three: 69,
        round_four: 72,
        total: 279,
        earnings: 3_240_000
      )

      expect(leaderboard.year).to eq(2023)
      expect(leaderboard.position).to eq(1)
      expect(leaderboard.round_one).to eq(68)
      expect(leaderboard.round_two).to eq(70)
      expect(leaderboard.round_three).to eq(69)
      expect(leaderboard.round_four).to eq(72)
      expect(leaderboard.total).to eq(279)
      expect(leaderboard.earnings).to eq(3_240_000)
    end

    it "allows partial round data" do
      leaderboard = Leaderboard.create!(
        golfer_id: golfer.player_id,
        year: 2023,
        round_one: 68
      )

      expect(leaderboard.round_one).to eq(68)
      expect(leaderboard.round_two).to be_nil
      expect(leaderboard.round_three).to be_nil
      expect(leaderboard.round_four).to be_nil
    end
  end

  describe "querying" do
    it "can find entries by golfer and year" do
      Leaderboard.create!(golfer_id: golfer.player_id, year: 2022, position: 5)
      entry_2023 = Leaderboard.create!(golfer_id: golfer.player_id, year: 2023, position: 1)

      found = Leaderboard.find_by(golfer_id: golfer.player_id, year: 2023)
      expect(found).to eq(entry_2023)
    end

    it "returns nil when entry not found" do
      found = Leaderboard.find_by(golfer_id: golfer.player_id, year: 2025)
      expect(found).to be_nil
    end
  end
end
