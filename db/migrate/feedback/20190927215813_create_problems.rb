class CreateProblems < ActiveRecord::Migration[6.0]
  def change
    create_table :problems do |t|
      t.references :feedback_contact, null: false, foreign_key: true
      t.text :details, null: false
      t.boolean :primary, default: false, null: false

      t.timestamps
    end
  end
end
