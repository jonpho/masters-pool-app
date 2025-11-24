require 'rails_helper'

RSpec.describe 'Flights API', type: :request do
  # Create a user for authentication
  let(:user) { User.create(email: 'test@example.com', password: 'password123') }

  before do
    # Sign in the user for authenticated requests
    sign_in user
  end

  describe 'GET /flights' do
    context 'with no flights' do
      it 'returns HTTP success' do
        get flights_path
        expect(response).to have_http_status(:success)
      end

      it 'renders the index template' do
        get flights_path
        expect(response).to render_template(:index)
      end

      it 'assigns an empty @flights collection' do
        get flights_path
        expect(assigns(:flights)).to be_empty
      end
    end

    context 'with flights' do
      let!(:flight_a) { Flight.create(name: 'Flight A') }
      let!(:flight_b) { Flight.create(name: 'Flight B') }
      let!(:flight_c) { Flight.create(name: 'Flight C') }

      it 'returns HTTP success' do
        get flights_path
        expect(response).to have_http_status(:success)
      end

      it 'assigns all flights to @flights' do
        get flights_path
        expect(assigns(:flights)).to match_array([flight_a, flight_b, flight_c])
      end

      it 'includes all flight names in response' do
        get flights_path
        expect(response.body).to include('Flight A')
        expect(response.body).to include('Flight B')
        expect(response.body).to include('Flight C')
      end
    end

    context 'with flights and associated golfers' do
      let!(:flight) { Flight.create(name: 'Flight Premium') }
      let!(:golfer1) { Golfer.create(name: 'Top Golfer 1', world_ranking: '1') }
      let!(:golfer2) { Golfer.create(name: 'Top Golfer 2', world_ranking: '2') }

      before do
        flight.golfers << [golfer1, golfer2]
      end

      it 'returns HTTP success' do
        get flights_path
        expect(response).to have_http_status(:success)
      end

      it 'assigns flights with their golfers' do
        get flights_path
        assigned_flight = assigns(:flights).find { |f| f.name == 'Flight Premium' }
        expect(assigned_flight).not_to be_nil
        expect(assigned_flight.golfers).to include(golfer1, golfer2)
      end
    end
  end

  describe 'authentication requirements' do
    before do
      sign_out user
    end

    it 'redirects to sign in when not authenticated' do
      get flights_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'does not allow access without authentication' do
      get flights_path
      expect(response).not_to have_http_status(:success)
    end
  end

  describe 'data integrity' do
    let!(:flight1) { Flight.create(name: 'Integrity Flight 1') }
    let!(:flight2) { Flight.create(name: 'Integrity Flight 2') }
    let!(:golfer) { Golfer.create(name: 'Integrity Golfer', world_ranking: '5') }

    before do
      flight1.golfers << golfer
    end

    it 'shows correct associations' do
      get flights_path
      flights = assigns(:flights)

      flight_with_golfer = flights.find { |f| f.name == 'Integrity Flight 1' }
      flight_without_golfer = flights.find { |f| f.name == 'Integrity Flight 2' }

      expect(flight_with_golfer.golfers).to include(golfer)
      expect(flight_without_golfer.golfers).to be_empty
    end
  end

  describe 'performance with large datasets' do
    before do
      20.times do |i|
        flight = Flight.create(name: "Flight #{i}")
        5.times do |j|
          golfer = Golfer.create(name: "Golfer #{i}-#{j}", world_ranking: "#{i * 5 + j + 1}")
          flight.golfers << golfer
        end
      end
    end

    it 'handles multiple flights efficiently' do
      get flights_path
      expect(response).to have_http_status(:success)
      expect(assigns(:flights).count).to eq(20)
    end

    it 'loads associated golfers' do
      get flights_path
      first_flight = assigns(:flights).first
      expect(first_flight.golfers.count).to eq(5)
    end
  end

  describe 'edge cases' do
    context 'with special characters in flight names' do
      let!(:flight) { Flight.create(name: "Flight A & B (2023-2024)") }

      it 'handles special characters correctly' do
        get flights_path
        expect(response).to have_http_status(:success)
        expect(assigns(:flights).first.name).to eq("Flight A & B (2023-2024)")
      end
    end

    context 'with very long flight names' do
      let!(:flight) { Flight.create(name: 'A' * 255) }

      it 'handles long names correctly' do
        get flights_path
        expect(response).to have_http_status(:success)
        expect(assigns(:flights).first.name.length).to eq(255)
      end
    end
  end
end
