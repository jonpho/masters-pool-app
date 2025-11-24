require 'rails_helper'

RSpec.describe Leaderboard, type: :model do
  describe 'associations' do
    it { should belong_to(:golfer).with_primary_key('player_id') }
  end

  describe 'validations' do
    let(:golfer) { Golfer.create(name: 'Test Golfer', world_ranking: '1') }

    subject do
      described_class.new(
        golfer_id: golfer.player_id,
        year: 2023,
        position: 1,
        round_one: 68,
        round_two: 70,
        round_three: 69,
        round_four: 71,
        total: 278,
        earnings: 3240000
      )
    end

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end

  describe 'factory creation' do
    let(:golfer) { Golfer.create(name: 'Jon Rahm', world_ranking: '1') }
    let(:leaderboard) do
      Leaderboard.create(
        golfer_id: golfer.player_id,
        year: 2023,
        position: 1,
        round_one: 67,
        round_two: 69,
        round_three: 70,
        round_four: 68,
        total: 274,
        earnings: 3240000
      )
    end

    it 'creates a leaderboard entry with all attributes' do
      expect(leaderboard).to be_persisted
      expect(leaderboard.golfer_id).to eq(golfer.player_id)
      expect(leaderboard.year).to eq(2023)
      expect(leaderboard.position).to eq(1)
      expect(leaderboard.total).to eq(274)
    end

    it 'associates with the correct golfer' do
      expect(leaderboard.golfer).to eq(golfer)
    end

    it 'has an id after creation' do
      expect(leaderboard.id).not_to be_nil
    end
  end

  describe 'round scores' do
    let(:golfer) { Golfer.create(name: 'Tiger Woods', world_ranking: '5') }
    let(:leaderboard) do
      Leaderboard.create(
        golfer_id: golfer.player_id,
        year: 2019,
        position: 1,
        round_one: 70,
        round_two: 68,
        round_three: 67,
        round_four: 70,
        total: 275,
        earnings: 2070000
      )
    end

    it 'stores all four round scores' do
      expect(leaderboard.round_one).to eq(70)
      expect(leaderboard.round_two).to eq(68)
      expect(leaderboard.round_three).to eq(67)
      expect(leaderboard.round_four).to eq(70)
    end

    it 'stores the total score' do
      expect(leaderboard.total).to eq(275)
    end
  end

  describe 'earnings' do
    let(:golfer) { Golfer.create(name: 'Jordan Spieth', world_ranking: '10') }
    let(:leaderboard) do
      Leaderboard.create(
        golfer_id: golfer.player_id,
        year: 2015,
        position: 1,
        total: 270,
        earnings: 1800000
      )
    end

    it 'stores earnings amount' do
      expect(leaderboard.earnings).to eq(1800000)
    end

    it 'can have earnings as integer' do
      expect(leaderboard.earnings).to be_a(Integer)
    end
  end

  describe 'querying' do
    let(:golfer1) { Golfer.create(name: 'Player One', world_ranking: '1') }
    let(:golfer2) { Golfer.create(name: 'Player Two', world_ranking: '2') }

    before do
      Leaderboard.create(golfer_id: golfer1.player_id, year: 2022, position: 1, total: 280)
      Leaderboard.create(golfer_id: golfer1.player_id, year: 2023, position: 2, total: 281)
      Leaderboard.create(golfer_id: golfer2.player_id, year: 2023, position: 1, total: 279)
    end

    it 'can find leaderboard by golfer and year' do
      entry = Leaderboard.find_by(golfer_id: golfer1.player_id, year: 2023)
      expect(entry).not_to be_nil
      expect(entry.position).to eq(2)
    end

    it 'can retrieve all entries for a specific year' do
      entries_2023 = Leaderboard.where(year: 2023)
      expect(entries_2023.count).to eq(2)
    end

    it 'can retrieve all entries for a specific golfer' do
      golfer1_entries = Leaderboard.where(golfer_id: golfer1.player_id)
      expect(golfer1_entries.count).to eq(2)
    end
  end

  describe 'updating entries' do
    let(:golfer) { Golfer.create(name: 'Rory McIlroy', world_ranking: '3') }
    let(:leaderboard) do
      Leaderboard.create(
        golfer_id: golfer.player_id,
        year: 2023,
        position: nil,
        round_one: 69
      )
    end

    it 'can update round scores' do
      leaderboard.update(round_two: 71, round_three: 68, round_four: 70)
      expect(leaderboard.round_two).to eq(71)
      expect(leaderboard.round_three).to eq(68)
      expect(leaderboard.round_four).to eq(70)
    end

    it 'can update position and total after tournament' do
      leaderboard.update(position: 3, total: 278)
      expect(leaderboard.position).to eq(3)
      expect(leaderboard.total).to eq(278)
    end

    it 'can update earnings' do
      leaderboard.update(earnings: 1500000)
      expect(leaderboard.earnings).to eq(1500000)
    end
  end

  describe 'nil values' do
    let(:golfer) { Golfer.create(name: 'Test Player', world_ranking: '15') }
    let(:partial_leaderboard) do
      Leaderboard.create(
        golfer_id: golfer.player_id,
        year: 2023,
        round_one: 72
      )
    end

    it 'allows nil values for incomplete tournaments' do
      expect(partial_leaderboard.round_two).to be_nil
      expect(partial_leaderboard.round_three).to be_nil
      expect(partial_leaderboard.round_four).to be_nil
      expect(partial_leaderboard.position).to be_nil
      expect(partial_leaderboard.total).to be_nil
    end
  end

  describe 'deletion behavior' do
    let(:golfer) { Golfer.create(name: 'Delete Test', world_ranking: '20') }
    let(:leaderboard) do
      Leaderboard.create(
        golfer_id: golfer.player_id,
        year: 2023,
        position: 5,
        total: 285
      )
    end

    it 'can be deleted independently' do
      leaderboard_id = leaderboard.id
      leaderboard.destroy
      expect(Leaderboard.find_by(id: leaderboard_id)).to be_nil
      expect(Golfer.find_by(player_id: golfer.player_id)).not_to be_nil
    end
  end
end
