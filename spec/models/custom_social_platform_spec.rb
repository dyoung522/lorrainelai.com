# frozen_string_literal: true

require "rails_helper"

RSpec.describe CustomSocialPlatform, type: :model do
  let(:site_profile) { SiteProfile.instance }

  describe "validations" do
    it "is valid with name and url" do
      platform = CustomSocialPlatform.new(name: "Bookshop", url: "https://bookshop.org", site_profile: site_profile)
      expect(platform).to be_valid
    end

    it "requires a name" do
      platform = CustomSocialPlatform.new(url: "https://bookshop.org", site_profile: site_profile)
      expect(platform).not_to be_valid
      expect(platform.errors[:name]).to include("can't be blank")
    end

    it "requires a url" do
      platform = CustomSocialPlatform.new(name: "Bookshop", site_profile: site_profile)
      expect(platform).not_to be_valid
      expect(platform.errors[:url]).to include("can't be blank")
    end

    it "validates url format" do
      platform = CustomSocialPlatform.new(name: "Bookshop", url: "not-a-url", site_profile: site_profile)
      expect(platform).not_to be_valid
      expect(platform.errors[:url]).to include("is not a valid URL")
    end

    it "validates name length (max 50 characters)" do
      platform = CustomSocialPlatform.new(name: "a" * 51, url: "https://example.com", site_profile: site_profile)
      expect(platform).not_to be_valid
      expect(platform.errors[:name]).to include("is too long (maximum is 50 characters)")
    end
  end

  describe "associations" do
    it "belongs to site_profile" do
      platform = CustomSocialPlatform.new(name: "Test", url: "https://example.com", site_profile: site_profile)
      expect(platform.site_profile).to eq(site_profile)
    end

    it "can have an icon attached" do
      platform = CustomSocialPlatform.create!(name: "Test", url: "https://example.com", site_profile: site_profile)
      expect(platform).to respond_to(:icon)
    end
  end

  describe "default scope" do
    it "orders by position ascending" do
      platform3 = CustomSocialPlatform.create!(name: "Third", url: "https://c.com", position: 3, site_profile: site_profile)
      platform1 = CustomSocialPlatform.create!(name: "First", url: "https://a.com", position: 1, site_profile: site_profile)
      platform2 = CustomSocialPlatform.create!(name: "Second", url: "https://b.com", position: 2, site_profile: site_profile)

      expect(CustomSocialPlatform.all).to eq([ platform1, platform2, platform3 ])
    end
  end

  describe "callbacks" do
    it "sets default position when not provided" do
      platform = CustomSocialPlatform.create!(name: "Test", url: "https://example.com", site_profile: site_profile)
      expect(platform.position).to eq(1)
    end

    it "sets position to next available when platforms exist" do
      CustomSocialPlatform.create!(name: "First", url: "https://a.com", position: 1, site_profile: site_profile)
      CustomSocialPlatform.create!(name: "Second", url: "https://b.com", position: 2, site_profile: site_profile)
      platform = CustomSocialPlatform.create!(name: "Third", url: "https://c.com", site_profile: site_profile)
      expect(platform.position).to eq(3)
    end
  end
end
