class CreateFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.string :title, null: false
      t.references :requester, foreign_key: { to_table: :contacts }, null: false
      t.references :web_widget, class_name: '::Channel::WebWidget', null: true
      t.references :account, null: false
      t.integer :funding_goal, default: 0
      t.string :status, null: false, default: 'review'

      t.timestamps
    end
  end
end
