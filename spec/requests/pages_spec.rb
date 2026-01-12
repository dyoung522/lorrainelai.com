# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    before do
      SiteProfile.create!(
        tagline: "Test tagline",
        about_me: "Test about me content"
      )
    end

    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "displays the site name" do
      get root_path
      expect(response.body).to include("Lorraine Lai")
    end

    it "displays the tagline" do
      get root_path
      expect(response.body).to include("Test tagline")
    end

    it "displays the about me content" do
      get root_path
      expect(response.body).to include("Test about me content")
    end

    context "with social links" do
      before do
        SiteProfile.first.update!(
          social_links: {
            "instagram" => "https://instagram.com/test",
            "linkedin" => ""
          }
        )
      end

      it "displays social links that are present" do
        get root_path
        expect(response.body).to include("https://instagram.com/test")
      end

      it "does not display empty social links" do
        get root_path
        # LinkedIn should not be rendered as a link since it's empty
        expect(response.body).not_to include('href="https://linkedin.com')
      end
    end

    context "without social links" do
      before do
        SiteProfile.first.update!(social_links: {})
      end

      it "does not display the social links section" do
        get root_path
        # Should not have the social links container when all are empty
        expect(response.body).not_to include("Instagram")
      end
    end
  end
end
