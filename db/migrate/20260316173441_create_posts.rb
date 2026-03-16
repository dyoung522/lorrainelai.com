class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description
      t.text :excerpt
      t.string :substack_url, null: false
      t.datetime :published_at
      t.integer :reading_time_minutes
      t.integer :likes, default: 0
      t.string :cover_image_url
      t.string :author
      t.boolean :paywall, default: false

      t.timestamps
    end

    add_index :posts, :slug, unique: true
  end
end
