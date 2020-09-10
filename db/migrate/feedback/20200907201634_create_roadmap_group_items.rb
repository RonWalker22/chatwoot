class CreateRoadmapGroupItems < ActiveRecord::Migration[6.0]
  def change
    create_table :roadmap_group_items do |t|
      t.references :roadmap_item, null: false
      t.references :roadmap_group, null: false

      t.timestamps
    end
  end
end
