require 'swagger_helper'

describe 'Leaderboards API' do
  path '/single_entry' do
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

      response '201', 'Leaderboard entry successful' do
        let!(:golfer_scorecard) { {golfer_id: 1, year: 2023, round_one: 69} }
        schema type: :object,
          properties: {
            message: {type: :string}
          }
        run_test!
      end
    end
  end
end
