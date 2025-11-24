require 'swagger_helper'

describe 'Leaderboards API' do
  # Create a user and golfer for testing
  let!(:user) { User.create(email: 'test@example.com', password: 'password123') }
  let!(:golfer) { Golfer.create(name: 'Test Golfer', world_ranking: '1') }

  before do
    sign_in user
  end

  path '/leaderboards/single_entry' do
    post 'Create New entry' do
      tags 'Single Entry'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :golfer_scorecard, in: :body, schema: {
        type: :object,
        properties: {
          golfer_id: {type: :string},
          year: {type: :integer},
          position: {type: :integer},
          round_one: {type: :integer},
          round_two: {type: :integer},
          round_three: {type: :integer},
          round_four: {type: :integer},
          total: {type: :integer},
          earnings: {type: :integer}
        },
        required: ['golfer_id']
      }

      response '200', 'Leaderboard entry successful' do
        let(:golfer_scorecard) do
          {
            golfer_id: golfer.player_id,
            year: 2023,
            position: 1,
            round_one: 69,
            round_two: 70,
            round_three: 68,
            round_four: 71,
            total: 278,
            earnings: 3240000
          }
        end

        schema type: :object,
          properties: {
            message: {type: :string}
          }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Success')
        end
      end

      response '422', 'Leaderboard entry failed' do
        let(:golfer_scorecard) do
          {
            golfer_id: 999999,
            year: 2023
          }
        end

        run_test!
      end
    end
  end

  path '/leaderboards' do
    get 'Retrieve all leaderboard entries' do
      tags 'Leaderboards'
      produces 'text/html'

      response '200', 'leaderboard entries found' do
        before do
          Leaderboard.create(
            golfer_id: golfer.player_id,
            year: 2023,
            position: 1,
            total: 278
          )
        end

        run_test! do |response|
          expect(response.body).to be_present
        end
      end
    end
  end
end
