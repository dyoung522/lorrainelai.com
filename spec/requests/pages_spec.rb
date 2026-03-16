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

  describe "GET /musings" do
    it "returns http success" do
      get musings_path
      expect(response).to have_http_status(:success)
    end

    it "displays the page title" do
      get musings_path
      expect(response.body).to include("Musings")
    end

    context "with published posts" do
      before do
        Post.create!(
          title: "My First Musing",
          slug: "my-first-musing",
          description: "A thoughtful post",
          excerpt: "This is the beginning of a great post about life and times.",
          substack_url: "https://example.substack.com/p/my-first-musing",
          published_at: 1.day.ago,
          reading_time_minutes: 5,
          author: "Lorraine Lai",
          cover_image_url: "https://cdn.substack.com/image/cover.jpg"
        )
        Post.create!(
          title: "Draft Post",
          slug: "draft-post",
          substack_url: "https://example.substack.com/p/draft-post",
          published_at: nil
        )
      end

      it "displays published posts" do
        get musings_path
        expect(response.body).to include("My First Musing")
      end

      it "does not display unpublished posts" do
        get musings_path
        expect(response.body).not_to include("Draft Post")
      end

      it "displays post metadata" do
        get musings_path
        expect(response.body).to include("5 min read")
        expect(response.body).to include("Read on Substack")
      end

      it "links to the Substack post" do
        get musings_path
        expect(response.body).to include("https://example.substack.com/p/my-first-musing")
      end
    end

    context "with no posts" do
      it "displays an empty state message" do
        get musings_path
        expect(response.body).to include("No musings yet")
      end
    end
  end
end
