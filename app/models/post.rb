# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :substack_url, presence: true

  scope :published, -> { where.not(published_at: nil) }
  scope :newest_first, -> { order(published_at: :desc) }
end
