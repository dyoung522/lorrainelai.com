# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::SiteProfile", type: :request do
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

  describe "GET /admin/site_profile/edit" do
    context "when not authenticated" do
      it "redirects to root" do
        get edit_admin_site_profile_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated" do
      before { sign_in_admin }

      it "returns http success" do
        get edit_admin_site_profile_path
        expect(response).to have_http_status(:success)
      end

      it "renders the edit form" do
        get edit_admin_site_profile_path
        expect(response.body).to include("form")
      end
    end
  end

  describe "PATCH /admin/site_profile" do
    context "when not authenticated" do
      it "redirects to root" do
        patch admin_site_profile_path, params: { site_profile: { tagline: "New tagline" } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated" do
      before { sign_in_admin }

      it "updates the tagline" do
        patch admin_site_profile_path, params: { site_profile: { tagline: "Updated tagline" } }
        expect(site_profile.reload.tagline).to eq("Updated tagline")
      end

      it "updates the about_me" do
        patch admin_site_profile_path, params: { site_profile: { about_me: "New about text" } }
        expect(site_profile.reload.about_me).to eq("New about text")
      end

      it "updates social links" do
        patch admin_site_profile_path, params: {
          site_profile: {
            social_links: {
              "instagram" => "https://instagram.com/new",
              "linkedin" => "https://linkedin.com/in/new"
            }
          }
        }
        expect(site_profile.reload.social_link(:instagram)).to eq("https://instagram.com/new")
        expect(site_profile.reload.social_link(:linkedin)).to eq("https://linkedin.com/in/new")
      end

      it "redirects to root on HTML request" do
        patch admin_site_profile_path, params: { site_profile: { tagline: "Test" } }
        expect(response).to redirect_to(root_path)
      end

      context "with turbo_stream request" do
        it "redirects to root" do
          patch admin_site_profile_path,
                params: { site_profile: { tagline: "Test" } },
                headers: { "Accept" => "text/vnd.turbo-stream.html" }
          expect(response).to redirect_to(root_path)
        end
      end

      context "with invalid params" do
        it "returns unprocessable entity for invalid tagline" do
          patch admin_site_profile_path, params: { site_profile: { tagline: "a" * 201 } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "GET /admin/site_profile/edit_field" do
    context "when authenticated" do
      before { sign_in_admin }

      it "returns the edit form for tagline" do
        get edit_field_admin_site_profile_path(field: "tagline")
        expect(response).to have_http_status(:success)
        expect(response.body).to include("tagline")
      end

      it "returns the edit form for about_me" do
        get edit_field_admin_site_profile_path(field: "about_me")
        expect(response).to have_http_status(:success)
        expect(response.body).to include("about_me")
      end

      it "returns the edit form for social_links" do
        get edit_field_admin_site_profile_path(field: "social_links")
        expect(response).to have_http_status(:success)
      end

      it "returns the edit form for profile_picture" do
        get edit_field_admin_site_profile_path(field: "profile_picture")
        expect(response).to have_http_status(:success)
      end
    end
  end
end
