# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :request do
  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  describe "GET /auth/google_oauth2/callback" do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "123456789",
        info: {
          email: "lorraine@example.com",
          name: "Lorraine Lai"
        }
      )
    end

    before do
      OmniAuth.config.mock_auth[:google_oauth2] = auth_hash
    end

    context "with authorized email" do
      before do
        allow(Rails.application.credentials).to receive(:dig)
          .with(:admin_emails)
          .and_return(["lorraine@example.com"])
      end

      it "creates a user and signs them in" do
        expect {
          get "/auth/google_oauth2/callback"
        }.to change(User, :count).by(1)
      end

      it "redirects to root with success notice" do
        get "/auth/google_oauth2/callback"
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Signed in successfully")
      end

      it "sets the user_id in session" do
        get "/auth/google_oauth2/callback"
        user = User.last
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context "with unauthorized email" do
      before do
        allow(Rails.application.credentials).to receive(:dig)
          .with(:admin_emails)
          .and_return(["other@example.com"])
      end

      it "does not set the session" do
        get "/auth/google_oauth2/callback"
        expect(session[:user_id]).to be_nil
      end

      it "redirects to root with alert" do
        get "/auth/google_oauth2/callback"
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Unauthorized email address")
      end
    end
  end

  describe "GET /auth/failure" do
    it "redirects to root with alert" do
      get "/auth/failure", params: { message: "invalid_credentials" }
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Authentication failed")
    end
  end

  describe "DELETE /logout" do
    let(:user) { User.create!(email: "test@example.com", provider: "google_oauth2", uid: "123") }

    before do
      # Simulate being logged in
      allow(Rails.application.credentials).to receive(:dig)
        .with(:admin_emails)
        .and_return(["test@example.com"])
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "123",
        info: { email: "test@example.com", name: "Test" }
      )
      get "/auth/google_oauth2/callback"
    end

    it "clears the session" do
      delete "/logout"
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root with notice" do
      delete "/logout"
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Signed out")
    end
  end
end
