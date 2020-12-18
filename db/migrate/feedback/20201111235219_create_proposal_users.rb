class CreateProposalUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :proposal_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :proposal, null: false, foreign_key: true
      t.string :evaluation, null: false, default: 'undecided'
      t.timestamps
      t.index [:proposal_id, :user_id], name: 'index_proposal_user_uniqueness', unique: true
    end
  end
end
