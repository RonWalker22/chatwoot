class CreateFeedbackGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :feedback_groups do |t|
      t.string :title
      t.integer :priority
      t.boolean :active

      t.timestamps
    end
  end
end
