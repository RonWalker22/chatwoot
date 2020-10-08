class CreateRoadmapGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :roadmap_groups do |t|
      t.string :title, null: false
      t.references :inbox, null: false
      t.references :account, null: false
      t.text :body
      t.date :due_by
      t.string :status, null: false, default: 'later'

      t.timestamps
    end
  end
end
