# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::CustomSocialPlatforms", type: :request do
  let(:site_profile) { SiteProfile.instance }

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  def sign_in_admin
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "123456789",
      info: { email: "admin@example.com", name: "Admin User" }
    )
    allow(Rails.application.credentials).to receive(:dig).and_call_original
    allow(Rails.application.credentials).to receive(:dig)
      .with(:admin_emails)
      .and_return([ "admin@example.com" ])
    get "/auth/google_oauth2/callback"
  end

  describe "DELETE /admin/custom_social_platforms/:id" do
    let!(:custom_platform) { site_profile.custom_social_platforms.create!(name: "Test Platform", url: "https://example.com") }

    context "when not authenticated" do
      it "redirects to root" do
        delete admin_custom_social_platform_path(custom_platform)
        expect(response).to redirect_to(root_path)
      end

      it "does not delete the platform" do
        expect {
          delete admin_custom_social_platform_path(custom_platform)
        }.not_to change(CustomSocialPlatform, :count)
      end
    end

    context "when authenticated" do
      before { sign_in_admin }

      it "deletes the custom platform" do
        expect {
          delete admin_custom_social_platform_path(custom_platform)
        }.to change(CustomSocialPlatform, :count).by(-1)
      end

      it "redirects to root path after deletion" do
        delete admin_custom_social_platform_path(custom_platform)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /admin/custom_social_platforms" do
    context "when not authenticated" do
      it "redirects to root" do
        post admin_custom_social_platforms_path, params: { custom_social_platform: { name: "New Platform", url: "https://example.com" } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated" do
      before { sign_in_admin }

      it "creates a custom platform" do
        expect {
          post admin_custom_social_platforms_path, params: { custom_social_platform: { name: "New Platform", url: "https://example.com" } }
        }.to change(CustomSocialPlatform, :count).by(1)
      end

      it "redirects to root path after creation" do
        post admin_custom_social_platforms_path, params: { custom_social_platform: { name: "New Platform", url: "https://example.com" } }
        expect(response).to redirect_to(root_path)
      end

      it "returns unprocessable entity for invalid params" do
        post admin_custom_social_platforms_path, params: { custom_social_platform: { name: "", url: "https://example.com" } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /admin/custom_social_platforms/new" do
    context "when not authenticated" do
      it "redirects to root" do
        get new_admin_custom_social_platform_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated" do
      before { sign_in_admin }

      it "returns http success" do
        get new_admin_custom_social_platform_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /admin/custom_social_platforms/:id/edit" do
    let!(:custom_platform) { site_profile.custom_social_platforms.create!(name: "Test Platform", url: "https://example.com") }

    context "when not authenticated" do
      it "redirects to root" do
        get edit_admin_custom_social_platform_path(custom_platform)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated" do
      before { sign_in_admin }

      it "returns http success" do
        get edit_admin_custom_social_platform_path(custom_platform)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PATCH /admin/custom_social_platforms/:id" do
    let!(:custom_platform) { site_profile.custom_social_platforms.create!(name: "Test Platform", url: "https://example.com") }

    context "when not authenticated" do
      it "redirects to root" do
        patch admin_custom_social_platform_path(custom_platform), params: { custom_social_platform: { name: "Updated" } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated" do
      before { sign_in_admin }

      it "updates the custom platform" do
        patch admin_custom_social_platform_path(custom_platform), params: { custom_social_platform: { name: "Updated Name" } }
        expect(custom_platform.reload.name).to eq("Updated Name")
      end

      it "redirects to root path after update" do
        patch admin_custom_social_platform_path(custom_platform), params: { custom_social_platform: { name: "Updated" } }
        expect(response).to redirect_to(root_path)
      end

      it "returns unprocessable entity for invalid params" do
        patch admin_custom_social_platform_path(custom_platform), params: { custom_social_platform: { name: "" } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
