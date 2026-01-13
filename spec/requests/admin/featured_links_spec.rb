# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::FeaturedLinks", type: :request do
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

  describe "POST /admin/featured_links" do
    context "when not authenticated" do
      it "redirects to root" do
        post admin_featured_links_path, params: { featured_link: { title: "My Blog", url: "https://example.com" } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated" do
      before { sign_in_admin }

      it "creates a featured link" do
        expect {
          post admin_featured_links_path, params: { featured_link: { title: "My Blog", url: "https://example.com" } }
        }.to change(FeaturedLink, :count).by(1)
      end

      it "redirects to root path after creation" do
        post admin_featured_links_path, params: { featured_link: { title: "My Blog", url: "https://example.com" } }
        expect(response).to redirect_to(root_path)
      end

      it "returns unprocessable entity for invalid params" do
        post admin_featured_links_path, params: { featured_link: { title: "", url: "https://example.com" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /admin/featured_links/new" do
    context "when not authenticated" do
      it "redirects to root" do
        get new_admin_featured_link_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated" do
      before { sign_in_admin }

      it "returns http success" do
        get new_admin_featured_link_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /admin/featured_links/:id/edit" do
    let!(:featured_link) { site_profile.featured_links.create!(title: "Test Link", url: "https://example.com") }

    context "when not authenticated" do
      it "redirects to root" do
        get edit_admin_featured_link_path(featured_link)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated" do
      before { sign_in_admin }

      it "returns http success" do
        get edit_admin_featured_link_path(featured_link)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PATCH /admin/featured_links/:id" do
    let!(:featured_link) { site_profile.featured_links.create!(title: "Test Link", url: "https://example.com") }

    context "when not authenticated" do
      it "redirects to root" do
        patch admin_featured_link_path(featured_link), params: { featured_link: { title: "Updated" } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated" do
      before { sign_in_admin }

      it "updates the featured link" do
        patch admin_featured_link_path(featured_link), params: { featured_link: { title: "Updated Title" } }
        expect(featured_link.reload.title).to eq("Updated Title")
      end

      it "redirects to root path after update" do
        patch admin_featured_link_path(featured_link), params: { featured_link: { title: "Updated" } }
        expect(response).to redirect_to(root_path)
      end

      it "returns unprocessable entity for invalid params" do
        patch admin_featured_link_path(featured_link), params: { featured_link: { title: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /admin/featured_links/:id" do
    let!(:featured_link) { site_profile.featured_links.create!(title: "Test Link", url: "https://example.com") }

    context "when not authenticated" do
      it "redirects to root" do
        delete admin_featured_link_path(featured_link)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated" do
      before { sign_in_admin }

      it "deletes the featured link" do
        expect {
          delete admin_featured_link_path(featured_link)
        }.to change(FeaturedLink, :count).by(-1)
      end

      it "redirects to root path after deletion" do
        delete admin_featured_link_path(featured_link)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
