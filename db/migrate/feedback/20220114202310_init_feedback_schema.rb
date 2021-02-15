class InitFeedbackSchema < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.string :title, null: false
      t.references :requester, polymorphic: true, null: true
      t.references :inbox, null: false
      t.references :account, null: false
      t.references :feedback_group, null: true
      t.string :status, null: false, default: 'review'
      t.string :kind, null: false, default: 'request'

      t.timestamps
    end
    create_table :feedback_contacts do |t|
      t.references :feedback, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true
      t.integer :prefund_level, default: 0, null: false
      t.integer :support_level, default: 0, null: false
      t.boolean :supporter, null: false, defatul: false

      t.timestamps
      t.index [:feedback_id, :contact_id], unique: true
    end
    create_table :proposals do |t|
      t.references :proposer, polymorphic: true, null: true
      t.references :feedback, null: false
      t.text :details, null: false
      t.boolean :primary, default: false, null: false
      t.boolean :solution, default: false, null: false

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
    create_table :clarification_threads do |t|
      t.references :feedback, null: false, foreign_key: true
      t.references :proposal, null: true, foreign_key: true

      t.timestamps
    end
    create_table :clarification_posts do |t|
      t.text :body, null: false
      t.references :author, polymorphic: true, null: true
      t.references :clarification_thread, null: false, foreign_key: true

      t.timestamps
    end
    create_table :roadmap_groups do |t|
      t.string :title, null: false
      t.references :inbox, null: false
      t.references :account, null: false
      t.text :body
      t.date :due_by
      t.string :status, null: false, default: 'later'

      t.timestamps
    end
    create_table :pro_cons do |t|
      t.text :body, null: false
      t.references :proposal_user, null: false, foreign_key: true
      t.boolean :pro, null: false, default: true
      t.timestamps
    end
    create_table :roadmap_items do |t|
      t.string :title
      t.text :body
      t.date :due_by
      t.string :status, null: false, default: 'later'
      t.references :feedback,
                   null: true,
                   foreign_key: true,
                   index: { unique: true }
      t.timestamps
    end
    create_table :roadmap_group_items do |t|
      t.references :roadmap_item, null: false
      t.references :roadmap_group, null: false

      t.timestamps
      t.index [:roadmap_item_id, :roadmap_group_id],
              name: 'roadmap_item_roadmap_group_index',
              unique: true
    end
    create_table :feedback_users do |t|
      t.references :feedback, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :evaluation, null: false, default: 'undecided'

      t.index [:feedback_id, :user_id], unique: true
      t.timestamps
    end
    create_table :feedback_groups do |t|
      t.string :title
      t.integer :priority
      t.boolean :active

      t.timestamps
    end
  end
end
