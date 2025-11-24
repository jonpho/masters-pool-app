require 'rails_helper'

RSpec.describe Golfer, type: :model do
  describe 'database configuration' do
    it 'uses player_id as primary key' do
      expect(Golfer.primary_key).to eq('player_id')
    end
  end

  describe 'associations' do
    it { should have_many(:leaderboards) }
    it { should have_and_belong_to_many(:flights) }
  end

  describe 'validations' do
    subject { described_class.new(name: 'Tiger Woods', world_ranking: '1') }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end

  describe 'factory creation' do
    let(:golfer) { Golfer.create(name: 'Rory McIlroy', world_ranking: '3') }

    it 'creates a golfer with a name' do
      expect(golfer.name).to eq('Rory McIlroy')
    end

    it 'creates a golfer with a world ranking' do
      expect(golfer.world_ranking).to eq('3')
    end

    it 'has a player_id after creation' do
      expect(golfer.player_id).not_to be_nil
    end
  end

  describe 'associations behavior' do
    let(:golfer) { Golfer.create(name: 'Jordan Spieth', world_ranking: '10') }
    let(:flight) { Flight.create(name: 'Flight A') }

    it 'can be associated with flights' do
      golfer.flights << flight
      expect(golfer.flights).to include(flight)
    end

    it 'can have multiple flights' do
      flight_b = Flight.create(name: 'Flight B')
      golfer.flights << [flight, flight_b]
      expect(golfer.flights.count).to eq(2)
    end

    it 'can have leaderboard entries' do
      leaderboard = Leaderboard.create(
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
      expect(golfer.leaderboards).to include(leaderboard)
    end
  end

  describe 'world ranking values' do
    it 'can have numeric rankings' do
      golfer = Golfer.create(name: 'Jon Rahm', world_ranking: '1')
      expect(golfer.world_ranking).to eq('1')
    end

    it 'can have "Unranked" as ranking' do
      golfer = Golfer.create(name: 'John Doe', world_ranking: 'Unranked')
      expect(golfer.world_ranking).to eq('Unranked')
    end

    it 'can have "Amateur" as ranking' do
      golfer = Golfer.create(name: 'Jane Smith', world_ranking: 'Amateur')
      expect(golfer.world_ranking).to eq('Amateur')
    end
  end

  describe 'deletion behavior' do
    let(:golfer) { Golfer.create(name: 'Test Golfer', world_ranking: '50') }
    let(:flight) { Flight.create(name: 'Flight C') }

    before do
      golfer.flights << flight
    end

    it 'removes associations when deleted' do
      golfer_id = golfer.player_id
      golfer.destroy
      expect(Golfer.find_by(player_id: golfer_id)).to be_nil
    end
  end
end
