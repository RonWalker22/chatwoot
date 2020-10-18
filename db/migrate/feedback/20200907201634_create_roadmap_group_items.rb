class CreateRoadmapGroupItems < ActiveRecord::Migration[6.0]
  def change
    create_table :roadmap_group_items do |t|
      t.references :roadmap_item, null: false
      t.references :roadmap_group, null: false

      t.timestamps
    end
    add_index :roadmap_group_items,
              [:roadmap_item_id, :roadmap_group_id],
              unique: true,
              name: 'roadmap_item_roadmap_group_index'
  end
end
