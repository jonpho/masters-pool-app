require 'rails_helper'

RSpec.describe UserSubmission, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:golfer).with_primary_key('player_id') }
  end

  describe 'validations' do
    let(:user) { User.create(email: 'test@example.com', password: 'password123') }
    let(:golfer) { Golfer.create(name: 'Test Golfer', world_ranking: '1') }

    subject do
      described_class.new(
        user_id: user.id,
        golfer_id: golfer.player_id
      )
    end

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end

  describe 'factory creation' do
    let(:user) { User.create(email: 'picker@example.com', password: 'password123') }
    let(:golfer) { Golfer.create(name: 'Jon Rahm', world_ranking: '1') }
    let(:submission) do
      UserSubmission.create(
        user_id: user.id,
        golfer_id: golfer.player_id
      )
    end

    it 'creates a submission with user and golfer' do
      expect(submission).to be_persisted
      expect(submission.user_id).to eq(user.id)
      expect(submission.golfer_id).to eq(golfer.player_id)
    end

    it 'associates with the correct user' do
      expect(submission.user).to eq(user)
    end

    it 'associates with the correct golfer' do
      expect(submission.golfer).to eq(golfer)
    end

    it 'has an id after creation' do
      expect(submission.id).not_to be_nil
    end
  end

  describe 'user picks multiple golfers' do
    let(:user) { User.create(email: 'multi@example.com', password: 'password123') }
    let(:golfer1) { Golfer.create(name: 'Tiger Woods', world_ranking: '1') }
    let(:golfer2) { Golfer.create(name: 'Rory McIlroy', world_ranking: '2') }
    let(:golfer3) { Golfer.create(name: 'Jordan Spieth', world_ranking: '3') }

    before do
      UserSubmission.create(user_id: user.id, golfer_id: golfer1.player_id)
      UserSubmission.create(user_id: user.id, golfer_id: golfer2.player_id)
      UserSubmission.create(user_id: user.id, golfer_id: golfer3.player_id)
    end

    it 'allows a user to submit multiple golfers' do
      user_picks = UserSubmission.where(user_id: user.id)
      expect(user_picks.count).to eq(3)
    end

    it 'tracks all golfers picked by user' do
      user_picks = UserSubmission.where(user_id: user.id)
      golfer_ids = user_picks.map(&:golfer_id)
      expect(golfer_ids).to include(golfer1.player_id, golfer2.player_id, golfer3.player_id)
    end
  end

  describe 'golfer picked by multiple users' do
    let(:user1) { User.create(email: 'user1@example.com', password: 'password123') }
    let(:user2) { User.create(email: 'user2@example.com', password: 'password123') }
    let(:user3) { User.create(email: 'user3@example.com', password: 'password123') }
    let(:popular_golfer) { Golfer.create(name: 'Scottie Scheffler', world_ranking: '1') }

    before do
      UserSubmission.create(user_id: user1.id, golfer_id: popular_golfer.player_id)
      UserSubmission.create(user_id: user2.id, golfer_id: popular_golfer.player_id)
      UserSubmission.create(user_id: user3.id, golfer_id: popular_golfer.player_id)
    end

    it 'allows multiple users to pick the same golfer' do
      picks = UserSubmission.where(golfer_id: popular_golfer.player_id)
      expect(picks.count).to eq(3)
    end

    it 'tracks all users who picked a golfer' do
      picks = UserSubmission.where(golfer_id: popular_golfer.player_id)
      user_ids = picks.map(&:user_id)
      expect(user_ids).to include(user1.id, user2.id, user3.id)
    end
  end

  describe 'querying submissions' do
    let(:user1) { User.create(email: 'query1@example.com', password: 'password123') }
    let(:user2) { User.create(email: 'query2@example.com', password: 'password123') }
    let(:golfer1) { Golfer.create(name: 'Player A', world_ranking: '5') }
    let(:golfer2) { Golfer.create(name: 'Player B', world_ranking: '10') }

    before do
      UserSubmission.create(user_id: user1.id, golfer_id: golfer1.player_id)
      UserSubmission.create(user_id: user1.id, golfer_id: golfer2.player_id)
      UserSubmission.create(user_id: user2.id, golfer_id: golfer1.player_id)
    end

    it 'can find submissions by user' do
      user1_picks = UserSubmission.where(user_id: user1.id)
      expect(user1_picks.count).to eq(2)
    end

    it 'can find submissions by golfer' do
      golfer1_picks = UserSubmission.where(golfer_id: golfer1.player_id)
      expect(golfer1_picks.count).to eq(2)
    end

    it 'can find specific user-golfer combination' do
      submission = UserSubmission.find_by(user_id: user1.id, golfer_id: golfer2.player_id)
      expect(submission).not_to be_nil
    end
  end

  describe 'deletion behavior' do
    let(:user) { User.create(email: 'delete@example.com', password: 'password123') }
    let(:golfer) { Golfer.create(name: 'Delete Golfer', world_ranking: '15') }
    let(:submission) do
      UserSubmission.create(user_id: user.id, golfer_id: golfer.player_id)
    end

    it 'can be deleted' do
      submission_id = submission.id
      submission.destroy
      expect(UserSubmission.find_by(id: submission_id)).to be_nil
    end

    it 'does not delete user when submission is deleted' do
      user_id = user.id
      submission.destroy
      expect(User.find_by(id: user_id)).not_to be_nil
    end

    it 'does not delete golfer when submission is deleted' do
      golfer_id = golfer.player_id
      submission.destroy
      expect(Golfer.find_by(player_id: golfer_id)).not_to be_nil
    end
  end

  describe 'timestamps' do
    let(:user) { User.create(email: 'timestamp@example.com', password: 'password123') }
    let(:golfer) { Golfer.create(name: 'Timestamp Golfer', world_ranking: '8') }
    let(:submission) do
      UserSubmission.create(user_id: user.id, golfer_id: golfer.player_id)
    end

    it 'has created_at timestamp' do
      expect(submission.created_at).not_to be_nil
    end

    it 'has updated_at timestamp' do
      expect(submission.updated_at).not_to be_nil
    end
  end
end
