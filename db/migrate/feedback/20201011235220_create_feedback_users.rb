class CreateFeedbackUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :feedback_users do |t|
      t.references :feedback, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :evaluation, null: false, default: 'undecided'
      t.timestamps
      t.index [:feedback_id, :user_id], unique: true
    end
  end
end
