class CreateCustomSocialPlatforms < ActiveRecord::Migration[8.1]
  def change
    create_table :custom_social_platforms do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.integer :position, null: false, default: 0
      t.references :site_profile, null: false, foreign_key: true

      t.timestamps
    end

    add_index :custom_social_platforms, [ :site_profile_id, :position ]
  end
end
