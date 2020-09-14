class CreateClarificationPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :clarification_posts do |t|
      t.text :body
      t.references :feedback_contact, null: false, foreign_key: true
      t.references :clarification_thread, null: false, foreign_key: true

      t.timestamps
    end
  end
end
