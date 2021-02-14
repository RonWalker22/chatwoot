class CreateRoadmapItems < ActiveRecord::Migration[6.0]
  def change
    create_table :roadmap_items do |t|
      t.string :title
      t.text :body
      t.date :due_by
      t.string :status, null: false, default: 'later'
      t.references :feedback,
                   null: true,
                   foreign_key: true,
                   index: { unique: true }
      t.timestamps
    end
  end
end
