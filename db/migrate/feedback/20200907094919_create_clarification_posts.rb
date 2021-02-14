class CreateClarificationPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :clarification_posts do |t|
      t.text :body, null: false
      t.references :author, polymorphic: true, null: true
      t.references :clarification_thread, null: false, foreign_key: true

      t.timestamps
    end
  end
end
