# frozen_string_literal: true

class FeaturedLink < ApplicationRecord
  belongs_to :site_profile

  validates :title, presence: true, length: { maximum: 100 }
  validates :url, presence: true, format: {
    with: /\Ahttps?:\/\/[^\s]+\z/,
    message: "is not a valid URL"
  }

  default_scope { order(:position) }

  before_validation :set_default_position, on: :create

  private

  def set_default_position
    return if position.present? && position > 0

    max_position = site_profile&.featured_links&.maximum(:position) || 0
    self.position = max_position + 1
  end
end
