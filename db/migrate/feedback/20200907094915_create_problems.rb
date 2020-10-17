class CreateProblems < ActiveRecord::Migration[6.0]
  def change
    create_table :problems do |t|
      t.references :proposer, polymorphic: true, null: false
      t.references :feedback, null: false
      t.text :details, null: false
      t.boolean :primary, default: false, null: false

      t.timestamps
    end
  end
end
