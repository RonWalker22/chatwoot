class CreateFeedbackUserProposals < ActiveRecord::Migration[6.0]
  def change
    create_table :feedback_user_proposals do |t|
      t.references :feedback_user, null: false, foreign_key: true
      t.references :proposal, null: false, foreign_key: true
      t.string :evaluation, null: false, default: 'undecided'
      t.timestamps
      t.index [:proposal_id, :feedback_user_id], name: 'index_proposal_feedback_user_uniqueness', unique: true
    end
  end
end
