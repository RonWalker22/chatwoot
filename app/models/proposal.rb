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
  has_many :proposal_users, dependent: :destroy
  has_many :pro_cons, through: :proposal_users

  after_create :create_thread

  def proposer_name
    proposer_type == 'FeedbackContact' ? proposer.contact.name : proposer.user.name
  end

  def extra_details
    find_proposal_user
    {
      proposer: proposer_name,
      thread: clarification_thread.id,
      proposal_user_id: proposal_user_id,
      evaluation: proposal_evaluation,
      score: proposal_score,
      pro_cons: format_pro_cons
    }
  end

  private

  def find_proposal_user
    @proposal_user = ProposalUser.find_by proposal: self, user: Current.user
  end

  def create_thread
    ClarificationThread.create feedback: feedback, proposal: self
  end

  def proposal_evaluation
    @proposal_user ? @proposal_user.evaluation : 'undecided'
  end

  def proposal_user_id
    @proposal_user ? @proposal_user.id : 0
  end

  def proposal_score
    up_votes = ProposalUser.all.where(proposal_id: id,
                                      evaluation: 'support').count
    down_votes = ProposalUser.all.where(proposal_id: id,
                                        evaluation: 'reject').count
    up_votes - down_votes
  end

  def format_pro_cons
    result = []
    pro_cons.each do |pro_con|
      result.push pro_con.as_json.merge user_name: pro_con.user.available_name
    end
    result
  end
end
