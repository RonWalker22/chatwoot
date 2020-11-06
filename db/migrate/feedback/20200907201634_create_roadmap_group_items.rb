class CreateRoadmapGroupItems < ActiveRecord::Migration[6.0]
  def change
    create_table :roadmap_group_items do |t|
      t.references :roadmap_item, null: false
      t.references :roadmap_group, null: false

      t.timestamps
      t.index [:roadmap_item_id, :roadmap_group_id],
              name: 'roadmap_item_roadmap_group_index',
              unique: true
    end
  end
end
