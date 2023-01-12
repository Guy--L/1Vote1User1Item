class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.integer :item_id, null: false, index: { unique: true }
      t.datetime :item_created_at, null: false
      t.string :item_type, null: false
      t.string :by, null: false
      t.string :title, null: false
      t.string :url, null: false
      t.integer :cached_votes_total, default: 0

      t.timestamps
    end
  end
end
