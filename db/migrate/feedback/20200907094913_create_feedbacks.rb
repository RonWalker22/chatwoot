class CreateFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.string :title, null: false
      t.references :requester, foreign_key: { to_table: :contacts }, null: false
      t.references :inbox, null: false
      t.references :account, null: false
      t.integer :funding_goal, default: 0
      t.string :status, null: false, default: 'review'
      t.string :kind, null: false, default: 'request'

      t.timestamps
    end
  end
end
