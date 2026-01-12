# frozen_string_literal: true

class SiteProfile < ApplicationRecord
  SOCIAL_PLATFORMS = %w[instagram linkedin twitter youtube substack].freeze

  has_one_attached :profile_picture

  validates :tagline, length: { maximum: 200 }

  # Singleton pattern - there should only be one site profile
  def self.instance
    first || create!
  end

  # Retrieve a social link by platform name
  def social_link(platform)
    social_links&.dig(platform.to_s)
  end

  # Check if a social link is present and not blank
  def social_link_present?(platform)
    social_link(platform).present?
  end
end
