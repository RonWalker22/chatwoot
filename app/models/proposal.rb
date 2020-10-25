# == Schema Information
#
# Table name: proposals
#
#  id            :bigint           not null, primary key
#  details       :text             not null
#  primary       :boolean          default(FALSE), not null
#  proposer_type :string           not null
#  solution      :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  feedback_id   :bigint           not null
#  proposer_id   :bigint           not null
#
# Indexes
#
#  index_proposals_on_feedback_id                    (feedback_id)
#  index_proposals_on_proposer_type_and_proposer_id  (proposer_type,proposer_id)
#
class Proposal < ApplicationRecord
  validates :details, presence: true, allow_blank: false
  belongs_to :proposer, polymorphic: true
  belongs_to :feedback
  has_one :clarification_thread, dependent: :destroy
  has_many :clarification_posts, through: :clarification_thread

  after_create :create_thread

  def proposer_name
    proposer_type == 'FeedbackContact' ? proposer.contact.name : proposer.user.name
  end

  private

  def create_thread
    ClarificationThread.create feedback: feedback, proposal: self
  end
end
