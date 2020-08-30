class CreateSolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :solutions do |t|
      t.references :feedback_contact, null: false, foreign_key: true
      t.text :details, null: false
      t.boolean :primary, default: false, null: false

      t.timestamps
    end
  end
end
