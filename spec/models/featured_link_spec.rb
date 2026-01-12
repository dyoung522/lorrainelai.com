# frozen_string_literal: true

require "rails_helper"

RSpec.describe FeaturedLink, type: :model do
  let(:site_profile) { SiteProfile.instance }

  describe "validations" do
    it "is valid with title, url, and position" do
      link = FeaturedLink.new(title: "My Blog", url: "https://example.com", position: 1, site_profile: site_profile)
      expect(link).to be_valid
    end

    it "requires a title" do
      link = FeaturedLink.new(url: "https://example.com", position: 1, site_profile: site_profile)
      expect(link).not_to be_valid
      expect(link.errors[:title]).to include("can't be blank")
    end

    it "requires a url" do
      link = FeaturedLink.new(title: "My Blog", position: 1, site_profile: site_profile)
      expect(link).not_to be_valid
      expect(link.errors[:url]).to include("can't be blank")
    end

    it "validates url format" do
      link = FeaturedLink.new(title: "My Blog", url: "not-a-url", position: 1, site_profile: site_profile)
      expect(link).not_to be_valid
      expect(link.errors[:url]).to include("is not a valid URL")
    end

    it "accepts valid URLs" do
      valid_urls = [
        "https://example.com",
        "http://example.com/path",
        "https://sub.example.com/path?query=1"
      ]
      valid_urls.each do |url|
        link = FeaturedLink.new(title: "Test", url: url, position: 1, site_profile: site_profile)
        expect(link).to be_valid, "Expected #{url} to be valid"
      end
    end

    it "requires a site_profile" do
      link = FeaturedLink.new(title: "My Blog", url: "https://example.com", position: 1)
      expect(link).not_to be_valid
      expect(link.errors[:site_profile]).to include("must exist")
    end

    it "validates title length (max 100 characters)" do
      link = FeaturedLink.new(title: "a" * 101, url: "https://example.com", position: 1, site_profile: site_profile)
      expect(link).not_to be_valid
      expect(link.errors[:title]).to include("is too long (maximum is 100 characters)")
    end
  end

  describe "default scope" do
    it "orders by position ascending" do
      link3 = FeaturedLink.create!(title: "Third", url: "https://c.com", position: 3, site_profile: site_profile)
      link1 = FeaturedLink.create!(title: "First", url: "https://a.com", position: 1, site_profile: site_profile)
      link2 = FeaturedLink.create!(title: "Second", url: "https://b.com", position: 2, site_profile: site_profile)

      expect(FeaturedLink.all).to eq([link1, link2, link3])
    end
  end

  describe "associations" do
    it "belongs to site_profile" do
      link = FeaturedLink.new(title: "Test", url: "https://example.com", position: 1, site_profile: site_profile)
      expect(link.site_profile).to eq(site_profile)
    end
  end

  describe "callbacks" do
    it "sets default position when not provided" do
      link = FeaturedLink.create!(title: "Test", url: "https://example.com", site_profile: site_profile)
      expect(link.position).to eq(1)
    end

    it "sets position to next available when links exist" do
      FeaturedLink.create!(title: "First", url: "https://a.com", position: 1, site_profile: site_profile)
      FeaturedLink.create!(title: "Second", url: "https://b.com", position: 2, site_profile: site_profile)
      link = FeaturedLink.create!(title: "Third", url: "https://c.com", site_profile: site_profile)
      expect(link.position).to eq(3)
    end
  end
end
