# frozen_string_literal: true

class CreateSiteProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :site_profiles do |t|
      t.string :tagline
      t.text :about_me
      t.json :social_links, default: {}

      t.timestamps
    end
  end
end
