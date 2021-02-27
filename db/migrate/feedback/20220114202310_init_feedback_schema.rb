class InitFeedbackSchema < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.string :title, null: false
      t.integer :display_id, null: false
      t.references :user, null: false
      t.references :inbox, null: false
      t.references :account, null: false
      t.string :status, null: false, default: 'preview'
      t.string :kind, null: false, default: 'request'
      t.index [:account_id, :display_id], name: 'index_feedbacks_on_account_id_and_display_id', unique: true

      t.timestamps
    end
    create_table :proposals do |t|
      t.references :user, null: false
      t.references :feedback, null: false
      t.text :details, null: false
      t.boolean :primary, default: false, null: false
      t.boolean :solution, default: false, null: false
      t.references :account, null: false

      t.timestamps
    end
    create_table :proposal_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :proposal, null: false, foreign_key: true
      t.boolean :voted, null: false, default: false
      t.string :evaluation, null: false, default: 'undecided'
      t.timestamps
      t.index [:proposal_id, :user_id], name: 'index_proposal_user_uniqueness', unique: true
    end
    create_table :clarification_posts do |t|
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.references :proposal, null: false, foreign_key: true

      t.timestamps
    end
    create_table :pro_cons do |t|
      t.text :body, null: false
      t.references :user, null: false
      t.references :account, null: false
      t.references :proposal, null: false
      t.boolean :pro, null: false, default: true
      t.timestamps
    end
    create_table :feedback_users do |t|
      t.references :feedback, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :evaluation, null: false, default: 'undecided'

      t.index [:feedback_id, :user_id], unique: true
      t.timestamps
    end
  end
end
