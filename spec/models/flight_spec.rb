require 'rails_helper'

RSpec.describe Flight, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:golfers) }
  end

  describe 'validations' do
    subject { described_class.new(name: 'Flight A') }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end

  describe 'factory creation' do
    let(:flight) { Flight.create(name: 'Flight B') }

    it 'creates a flight with a name' do
      expect(flight.name).to eq('Flight B')
    end

    it 'has an id after creation' do
      expect(flight.id).not_to be_nil
    end

    it 'persists to database' do
      expect(flight).to be_persisted
    end
  end

  describe 'associations behavior' do
    let(:flight) { Flight.create(name: 'Flight C') }
    let(:golfer1) { Golfer.create(name: 'Tiger Woods', world_ranking: '1') }
    let(:golfer2) { Golfer.create(name: 'Phil Mickelson', world_ranking: '5') }

    it 'can be associated with golfers' do
      flight.golfers << golfer1
      expect(flight.golfers).to include(golfer1)
    end

    it 'can have multiple golfers' do
      flight.golfers << [golfer1, golfer2]
      expect(flight.golfers.count).to eq(2)
      expect(flight.golfers).to include(golfer1, golfer2)
    end

    it 'maintains bidirectional association' do
      flight.golfers << golfer1
      expect(golfer1.flights).to include(flight)
    end

    it 'can remove golfers' do
      flight.golfers << [golfer1, golfer2]
      flight.golfers.delete(golfer1)
      expect(flight.golfers).not_to include(golfer1)
      expect(flight.golfers).to include(golfer2)
    end
  end

  describe 'querying' do
    before do
      Flight.create(name: 'Flight A')
      Flight.create(name: 'Flight B')
      Flight.create(name: 'Flight C')
    end

    it 'can retrieve all flights' do
      expect(Flight.count).to eq(3)
    end

    it 'can find flight by name' do
      flight = Flight.find_by(name: 'Flight A')
      expect(flight).not_to be_nil
      expect(flight.name).to eq('Flight A')
    end
  end

  describe 'deletion behavior' do
    let(:flight) { Flight.create(name: 'Flight D') }
    let(:golfer) { Golfer.create(name: 'Test Golfer', world_ranking: '10') }

    before do
      flight.golfers << golfer
    end

    it 'can be deleted' do
      flight_id = flight.id
      flight.destroy
      expect(Flight.find_by(id: flight_id)).to be_nil
    end

    it 'removes join table entries when deleted' do
      flight_id = flight.id
      golfer_id = golfer.player_id
      flight.destroy

      # The golfer should still exist
      expect(Golfer.find_by(player_id: golfer_id)).not_to be_nil

      # But the association should be gone
      remaining_golfer = Golfer.find_by(player_id: golfer_id)
      expect(remaining_golfer.flights).not_to include(flight)
    end
  end

  describe 'empty flights' do
    let(:empty_flight) { Flight.create(name: 'Empty Flight') }

    it 'can exist without golfers' do
      expect(empty_flight.golfers).to be_empty
      expect(empty_flight).to be_persisted
    end

    it 'returns zero count for golfers' do
      expect(empty_flight.golfers.count).to eq(0)
    end
  end
end
