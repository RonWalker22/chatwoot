class CreateProposals < ActiveRecord::Migration[6.0]
  def change
    create_table :proposals do |t|
      t.references :proposer, polymorphic: true, null: true
      t.references :feedback, null: false
      t.text :details, null: false
      t.boolean :primary, default: false, null: false
      t.boolean :solution, default: false, null: false

      t.timestamps
    end
  end
end
