require 'rails_helper'

RSpec.describe 'Leaderboards', type: :request do
  let(:user) { User.create(email: 'test@example.com', password: 'password123') }
  let(:golfer) { Golfer.create(name: 'Test Golfer', world_ranking: '1') }

  before do
    sign_in user
  end

  describe 'GET /leaderboards' do
    context 'with no leaderboard entries' do
      it 'returns HTTP success' do
        get leaderboards_path
        expect(response).to have_http_status(:success)
      end

      it 'renders the index template' do
        get leaderboards_path
        expect(response).to render_template(:index)
      end

      it 'assigns an empty @leaderboards collection' do
        get leaderboards_path
        expect(assigns(:leaderboards)).to be_empty
      end
    end

    context 'with leaderboard entries' do
      let!(:entry1) do
        Leaderboard.create(
          golfer_id: golfer.player_id,
          year: 2023,
          position: 1,
          round_one: 69,
          round_two: 70,
          round_three: 68,
          round_four: 71,
          total: 278,
          earnings: 3240000
        )
      end

      let!(:entry2) do
        golfer2 = Golfer.create(name: 'Second Golfer', world_ranking: '2')
        Leaderboard.create(
          golfer_id: golfer2.player_id,
          year: 2023,
          position: 2,
          total: 280,
          earnings: 1944000
        )
      end

      it 'returns HTTP success' do
        get leaderboards_path
        expect(response).to have_http_status(:success)
      end

      it 'assigns all leaderboard entries' do
        get leaderboards_path
        expect(assigns(:leaderboards)).to match_array([entry1, entry2])
      end
    end
  end

  describe 'POST /leaderboards/single_entry' do
    context 'creating a new leaderboard entry' do
      let(:valid_params) do
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

      it 'creates a new leaderboard entry' do
        expect {
          post leaderboards_single_entry_path, params: valid_params
        }.to change(Leaderboard, :count).by(1)
      end

      it 'returns HTTP success with JSON message' do
        post leaderboards_single_entry_path, params: valid_params
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['message']).to eq('Success')
      end

      it 'stores all round scores correctly' do
        post leaderboards_single_entry_path, params: valid_params
        entry = Leaderboard.last
        expect(entry.round_one).to eq(69)
        expect(entry.round_two).to eq(70)
        expect(entry.round_three).to eq(68)
        expect(entry.round_four).to eq(71)
      end

      it 'stores position and total correctly' do
        post leaderboards_single_entry_path, params: valid_params
        entry = Leaderboard.last
        expect(entry.position).to eq(1)
        expect(entry.total).to eq(278)
      end

      it 'stores earnings correctly' do
        post leaderboards_single_entry_path, params: valid_params
        entry = Leaderboard.last
        expect(entry.earnings).to eq(3240000)
      end
    end

    context 'updating an existing leaderboard entry' do
      let!(:existing_entry) do
        Leaderboard.create(
          golfer_id: golfer.player_id,
          year: 2023,
          position: nil,
          round_one: 69,
          round_two: 70
        )
      end

      let(:update_params) do
        {
          golfer_id: golfer.player_id,
          year: 2023,
          round_three: 68,
          round_four: 71,
          position: 1,
          total: 278,
          earnings: 3240000
        }
      end

      it 'does not create a new entry' do
        expect {
          post leaderboards_single_entry_path, params: update_params
        }.not_to change(Leaderboard, :count)
      end

      it 'updates the existing entry' do
        post leaderboards_single_entry_path, params: update_params
        existing_entry.reload
        expect(existing_entry.round_three).to eq(68)
        expect(existing_entry.round_four).to eq(71)
        expect(existing_entry.position).to eq(1)
        expect(existing_entry.total).to eq(278)
      end

      it 'returns HTTP success' do
        post leaderboards_single_entry_path, params: update_params
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['message']).to eq('Success')
      end

      it 'does not overwrite existing round scores' do
        post leaderboards_single_entry_path, params: update_params
        existing_entry.reload
        expect(existing_entry.round_one).to eq(69)
        expect(existing_entry.round_two).to eq(70)
      end
    end

    context 'partial updates' do
      let!(:existing_entry) do
        Leaderboard.create(
          golfer_id: golfer.player_id,
          year: 2023,
          round_one: 69
        )
      end

      it 'updates only provided fields' do
        post leaderboards_single_entry_path, params: {
          golfer_id: golfer.player_id,
          year: 2023,
          round_two: 70
        }

        existing_entry.reload
        expect(existing_entry.round_one).to eq(69)
        expect(existing_entry.round_two).to eq(70)
        expect(existing_entry.round_three).to be_nil
      end
    end

    context 'with invalid golfer_id' do
      let(:invalid_params) do
        {
          golfer_id: 999999,
          year: 2023,
          round_one: 69
        }
      end

      it 'returns unprocessable entity status' do
        post leaderboards_single_entry_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a leaderboard entry' do
        expect {
          post leaderboards_single_entry_path, params: invalid_params
        }.not_to change(Leaderboard, :count)
      end
    end
  end

  describe 'authentication requirements' do
    before do
      sign_out user
    end

    it 'redirects to sign in for index' do
      get leaderboards_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in for single_entry' do
      post leaderboards_single_entry_path, params: {
        golfer_id: golfer.player_id,
        year: 2023
      }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'multiple years handling' do
    let!(:entry_2022) do
      Leaderboard.create(
        golfer_id: golfer.player_id,
        year: 2022,
        position: 2,
        total: 281
      )
    end

    let!(:entry_2023) do
      Leaderboard.create(
        golfer_id: golfer.player_id,
        year: 2023,
        position: 1,
        total: 278
      )
    end

    it 'maintains separate entries for different years' do
      get leaderboards_path
      expect(assigns(:leaderboards).count).to eq(2)
    end

    it 'can update specific year without affecting others' do
      post leaderboards_single_entry_path, params: {
        golfer_id: golfer.player_id,
        year: 2023,
        position: 3
      }

      entry_2022.reload
      entry_2023.reload

      expect(entry_2022.position).to eq(2)
      expect(entry_2023.position).to eq(3)
    end
  end
end
