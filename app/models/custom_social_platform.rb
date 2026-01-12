# frozen_string_literal: true

class CustomSocialPlatform < ApplicationRecord
  belongs_to :site_profile

  has_one_attached :icon

  validates :name, presence: true, length: { maximum: 50 }
  validates :url, presence: true, format: {
    with: /\Ahttps?:\/\/[^\s]+\z/,
    message: "is not a valid URL"
  }

  default_scope { order(:position) }

  before_validation :set_default_position, on: :create

  private

  def set_default_position
    return if position.present? && position > 0

    max_position = site_profile&.custom_social_platforms&.maximum(:position) || 0
    self.position = max_position + 1
  end
end
