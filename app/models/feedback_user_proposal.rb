# == Schema Information
#
# Table name: feedback_user_proposals
#
#  id               :bigint           not null, primary key
#  evaluation       :string           default("undecided"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  feedback_user_id :bigint           not null
#  proposal_id      :bigint           not null
#
# Indexes
#
#  index_feedback_user_proposals_on_feedback_user_id  (feedback_user_id)
#  index_feedback_user_proposals_on_proposal_id       (proposal_id)
#  index_proposal_feedback_user_uniqueness            (proposal_id,feedback_user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (feedback_user_id => feedback_users.id)
#  fk_rails_...  (proposal_id => proposals.id)
#
class FeedbackUserProposal < ApplicationRecord
  belongs_to :proposal
  belongs_to :feedback_user
end
