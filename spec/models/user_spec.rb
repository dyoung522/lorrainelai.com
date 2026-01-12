# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with all required attributes" do
      user = User.new(
        email: "test@example.com",
        provider: "google_oauth2",
        uid: "123456789"
      )
      expect(user).to be_valid
    end

    it "requires email" do
      user = User.new(provider: "google_oauth2", uid: "123456789")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "requires provider" do
      user = User.new(email: "test@example.com", uid: "123456789")
      expect(user).not_to be_valid
      expect(user.errors[:provider]).to include("can't be blank")
    end

    it "requires uid" do
      user = User.new(email: "test@example.com", provider: "google_oauth2")
      expect(user).not_to be_valid
      expect(user.errors[:uid]).to include("can't be blank")
    end

    it "requires unique email" do
      User.create!(
        email: "test@example.com",
        provider: "google_oauth2",
        uid: "123456789"
      )
      duplicate = User.new(
        email: "test@example.com",
        provider: "google_oauth2",
        uid: "987654321"
      )
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include("has already been taken")
    end
  end

  describe ".from_omniauth" do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "123456789",
        info: {
          email: "test@example.com",
          name: "Test User"
        }
      )
    end

    context "when user does not exist" do
      it "creates a new user" do
        expect { User.from_omniauth(auth_hash) }.to change(User, :count).by(1)
      end

      it "returns the created user with correct attributes" do
        user = User.from_omniauth(auth_hash)

        expect(user.email).to eq("test@example.com")
        expect(user.name).to eq("Test User")
        expect(user.provider).to eq("google_oauth2")
        expect(user.uid).to eq("123456789")
      end
    end

    context "when user already exists" do
      before do
        User.create!(
          email: "test@example.com",
          name: "Test User",
          provider: "google_oauth2",
          uid: "123456789"
        )
      end

      it "does not create a new user" do
        expect { User.from_omniauth(auth_hash) }.not_to change(User, :count)
      end

      it "returns the existing user" do
        user = User.from_omniauth(auth_hash)
        expect(user.persisted?).to be true
      end
    end
  end
end
