class CreateFeedbackContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :feedback_contacts do |t|
      t.references :feedback, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true
      t.integer :prefund_level, default: 0, null: false
      t.integer :support_level, default: 0, null: false
      t.boolean :supporter, null: false, defatul: false

      t.timestamps
    end
  end
end
