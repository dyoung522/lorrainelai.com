class CreateFeaturedLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :featured_links do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.integer :position, null: false, default: 0
      t.references :site_profile, null: false, foreign_key: true

      t.timestamps
    end

    add_index :featured_links, [ :site_profile_id, :position ]
  end
end
