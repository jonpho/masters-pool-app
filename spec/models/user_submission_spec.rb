require 'rails_helper'

RSpec.describe UserSubmission, type: :model do
  let(:user) { User.create!(email: "test@example.com", password: "password123") }
  let(:golfer) { Golfer.create!(name: "Tiger Woods", world_ranking: "1") }

  describe "associations" do
    describe "#golfer" do
      it "belongs to golfer with custom primary key" do
        association = UserSubmission.reflect_on_association(:golfer)
        expect(association.macro).to eq(:belongs_to)
        expect(association.options[:primary_key]).to eq("player_id")
      end

      it "can access the associated golfer" do
        submission = UserSubmission.create!(user: user, golfer_id: golfer.player_id)

        expect(submission.golfer).to eq(golfer)
        expect(submission.golfer.name).to eq("Tiger Woods")
      end

      it "correctly references golfer using player_id" do
        submission = UserSubmission.create!(user: user, golfer_id: golfer.player_id)

        expect(submission.golfer_id).to eq(golfer.player_id)
      end
    end

    describe "#user" do
      it "belongs to user" do
        association = UserSubmission.reflect_on_association(:user)
        expect(association.macro).to eq(:belongs_to)
      end

      it "can access the associated user" do
        submission = UserSubmission.create!(user: user, golfer_id: golfer.player_id)

        expect(submission.user).to eq(user)
        expect(submission.user.email).to eq("test@example.com")
      end
    end
  end

  describe "creating submissions" do
    it "can create a submission linking user and golfer" do
      submission = UserSubmission.create!(user: user, golfer_id: golfer.player_id)

      expect(submission).to be_persisted
      expect(submission.user_id).to eq(user.id)
      expect(submission.golfer_id).to eq(golfer.player_id)
    end

    it "allows multiple submissions per user" do
      golfer2 = Golfer.create!(name: "Rory McIlroy", world_ranking: "2")

      UserSubmission.create!(user: user, golfer_id: golfer.player_id)
      UserSubmission.create!(user: user, golfer_id: golfer2.player_id)

      expect(UserSubmission.where(user: user).count).to eq(2)
    end
  end
end
