# == Schema Information
#
# Table name: clarification_threads
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  feedback_id :bigint           not null
#  proposal_id :bigint
#
# Indexes
#
#  index_clarification_threads_on_feedback_id  (feedback_id)
#  index_clarification_threads_on_proposal_id  (proposal_id)
#
# Foreign Keys
#
#  fk_rails_...  (feedback_id => feedbacks.id)
#  fk_rails_...  (proposal_id => proposals.id)
#
class ClarificationThread < ApplicationRecord
  belongs_to :feedback
  belongs_to :proposal, optional: true
  has_many :clarification_posts, dependent: :destroy
end
