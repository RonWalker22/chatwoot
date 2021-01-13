class CreateProCons < ActiveRecord::Migration[6.0]
  def change
    create_table :pro_cons do |t|
      t.text :body, null: false
      t.references :proposal_user, null: false, foreign_key: true
      t.boolean :pro, null: false, default: true
      t.timestamps
    end
  end
end
