# frozen_string_literal: true

require "rails_helper"

RSpec.describe SiteProfile, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      site_profile = SiteProfile.new(tagline: "Creative thinker")
      expect(site_profile).to be_valid
    end

    it "validates tagline length" do
      site_profile = SiteProfile.new(tagline: "a" * 201)
      expect(site_profile).not_to be_valid
      expect(site_profile.errors[:tagline]).to include("is too long (maximum is 200 characters)")
    end

    it "allows blank tagline" do
      site_profile = SiteProfile.new(tagline: "")
      expect(site_profile).to be_valid
    end
  end

  describe ".instance" do
    context "when no record exists" do
      it "creates a new record" do
        expect { SiteProfile.instance }.to change(SiteProfile, :count).by(1)
      end

      it "returns the created record" do
        site_profile = SiteProfile.instance
        expect(site_profile).to be_persisted
      end
    end

    context "when a record already exists" do
      before { SiteProfile.create! }

      it "does not create a new record" do
        expect { SiteProfile.instance }.not_to change(SiteProfile, :count)
      end

      it "returns the existing record" do
        existing = SiteProfile.first
        expect(SiteProfile.instance).to eq(existing)
      end
    end
  end

  describe "#social_link" do
    let(:site_profile) do
      SiteProfile.new(
        social_links: {
          "instagram" => "https://instagram.com/lorraine",
          "linkedin" => "https://linkedin.com/in/lorraine"
        }
      )
    end

    it "retrieves a social link by platform name as string" do
      expect(site_profile.social_link("instagram")).to eq("https://instagram.com/lorraine")
    end

    it "retrieves a social link by platform name as symbol" do
      expect(site_profile.social_link(:linkedin)).to eq("https://linkedin.com/in/lorraine")
    end

    it "returns nil for missing platform" do
      expect(site_profile.social_link(:twitter)).to be_nil
    end

    it "returns nil when social_links is nil" do
      site_profile = SiteProfile.new(social_links: nil)
      expect(site_profile.social_link(:instagram)).to be_nil
    end
  end

  describe "#social_link_present?" do
    let(:site_profile) do
      SiteProfile.new(
        social_links: {
          "instagram" => "https://instagram.com/lorraine",
          "twitter" => "",
          "linkedin" => nil
        }
      )
    end

    it "returns true for present social link" do
      expect(site_profile.social_link_present?(:instagram)).to be true
    end

    it "returns false for blank social link" do
      expect(site_profile.social_link_present?(:twitter)).to be false
    end

    it "returns false for nil social link" do
      expect(site_profile.social_link_present?(:linkedin)).to be false
    end

    it "returns false for missing social link" do
      expect(site_profile.social_link_present?(:youtube)).to be false
    end
  end

  describe "Active Storage attachment" do
    it "can have a profile picture attached" do
      site_profile = SiteProfile.create!
      expect(site_profile).to respond_to(:profile_picture)
    end
  end

  describe "social platforms" do
    it "defines the supported social platforms" do
      expect(SiteProfile::SOCIAL_PLATFORMS).to eq(
        %w[instagram linkedin twitter youtube substack]
      )
    end
  end
end
