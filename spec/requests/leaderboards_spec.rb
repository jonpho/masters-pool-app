require 'rails_helper'

RSpec.describe "Leaderboards", type: :request do
  let(:user) { User.create!(email: "test@example.com", password: "password123") }
  let(:golfer) { Golfer.create!(name: "Tiger Woods", world_ranking: "1") }

  describe "GET /leaderboards" do
    context "when authenticated" do
      before { sign_in user }

      it "returns a successful response" do
        get leaderboards_path
        expect(response).to have_http_status(:success)
      end

      it "returns all leaderboard entries" do
        Leaderboard.create!(golfer_id: golfer.player_id, year: 2023, position: 1)
        Leaderboard.create!(golfer_id: golfer.player_id, year: 2022, position: 5)

        get leaderboards_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when not authenticated" do
      it "redirects to sign in page" do
        get leaderboards_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /leaderboards/single_entry" do
    let(:valid_params) do
      {
        golfer_id: golfer.player_id,
        year: 2023,
        position: 1,
        round_one: 68,
        round_two: 70,
        round_three: 69,
        round_four: 72,
        total: 279,
        earnings: 3_240_000
      }
    end

    context "when authenticated" do
      before { sign_in user }

      context "creating a new leaderboard entry" do
        it "creates a new entry and returns success" do
          expect {
            post leaderboards_single_entry_path, params: valid_params
          }.to change(Leaderboard, :count).by(1)

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)["message"]).to eq("Success")
        end

        it "creates entry with correct attributes" do
          post leaderboards_single_entry_path, params: valid_params

          leaderboard = Leaderboard.last
          expect(leaderboard.golfer_id).to eq(golfer.player_id)
          expect(leaderboard.year).to eq(2023)
          expect(leaderboard.position).to eq(1)
          expect(leaderboard.round_one).to eq(68)
          expect(leaderboard.round_two).to eq(70)
          expect(leaderboard.round_three).to eq(69)
          expect(leaderboard.round_four).to eq(72)
          expect(leaderboard.total).to eq(279)
          expect(leaderboard.earnings).to eq(3_240_000)
        end

        it "creates entry with partial data" do
          partial_params = {
            golfer_id: golfer.player_id,
            year: 2023,
            round_one: 68
          }

          expect {
            post leaderboards_single_entry_path, params: partial_params
          }.to change(Leaderboard, :count).by(1)

          expect(response).to have_http_status(:ok)
          leaderboard = Leaderboard.last
          expect(leaderboard.round_one).to eq(68)
          expect(leaderboard.round_two).to be_nil
        end
      end

      context "updating an existing leaderboard entry" do
        let!(:existing_entry) do
          Leaderboard.create!(
            golfer_id: golfer.player_id,
            year: 2023,
            position: 10,
            round_one: 72
          )
        end

        it "updates the existing entry instead of creating a new one" do
          update_params = {
            golfer_id: golfer.player_id,
            year: 2023,
            position: 1,
            round_one: 68,
            round_two: 70
          }

          expect {
            post leaderboards_single_entry_path, params: update_params
          }.not_to change(Leaderboard, :count)

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)["message"]).to eq("Success")
        end

        it "updates only provided fields" do
          update_params = {
            golfer_id: golfer.player_id,
            year: 2023,
            round_two: 70
          }

          post leaderboards_single_entry_path, params: update_params

          existing_entry.reload
          expect(existing_entry.round_one).to eq(72) # unchanged
          expect(existing_entry.round_two).to eq(70) # updated
          expect(existing_entry.position).to eq(10)  # unchanged (not in params)
        end

        it "does not overwrite existing fields with nil" do
          update_params = {
            golfer_id: golfer.player_id,
            year: 2023,
            round_two: 70
            # round_one not provided, should not be overwritten
          }

          post leaderboards_single_entry_path, params: update_params

          existing_entry.reload
          expect(existing_entry.round_one).to eq(72)
        end
      end

      context "with different golfer/year combinations" do
        let!(:entry_2023) do
          Leaderboard.create!(golfer_id: golfer.player_id, year: 2023, round_one: 70)
        end

        it "creates new entry for same golfer different year" do
          params = { golfer_id: golfer.player_id, year: 2022, round_one: 72 }

          expect {
            post leaderboards_single_entry_path, params: params
          }.to change(Leaderboard, :count).by(1)
        end

        it "creates new entry for different golfer same year" do
          other_golfer = Golfer.create!(name: "Rory McIlroy", world_ranking: "2")
          params = { golfer_id: other_golfer.player_id, year: 2023, round_one: 68 }

          expect {
            post leaderboards_single_entry_path, params: params
          }.to change(Leaderboard, :count).by(1)
        end
      end
    end

    context "when not authenticated" do
      it "redirects to sign in page" do
        post leaderboards_single_entry_path, params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end

      it "does not create a leaderboard entry" do
        expect {
          post leaderboards_single_entry_path, params: valid_params
        }.not_to change(Leaderboard, :count)
      end
    end
  end
end
