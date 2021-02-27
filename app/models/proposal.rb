# == Schema Information
#
# Table name: proposals
#
#  id          :bigint           not null, primary key
#  details     :text             not null
#  primary     :boolean          default(FALSE), not null
#  solution    :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#  feedback_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_proposals_on_account_id   (account_id)
#  index_proposals_on_feedback_id  (feedback_id)
#  index_proposals_on_user_id      (user_id)
#
class Proposal < ApplicationRecord
  validates :details, presence: true, allow_blank: false
  belongs_to :user, optional: true
  belongs_to :feedback
  belongs_to :account
  has_many :clarification_posts, dependent: :destroy
  has_many :proposal_users, dependent: :destroy
  has_many :pro_cons, dependent: :destroy

  def proposer_name
    user ? user.available_name : ''
  end

  def extra_details
    find_proposal_user
    {
      user: proposer_name,
      evaluation: proposal_evaluation,
      proposal_user_id: proposal_user_id,
      score: proposal_score,
      pro_cons: format_pro_cons,
      date: created_at.strftime('%b %d %Y'),
      voted: proposal_voted
    }
  end

  private

  def find_proposal_user
    @proposal_user = ProposalUser.find_by proposal: self, user: Current.user
  end

  def proposal_evaluation
    @proposal_user ? @proposal_user.evaluation : 'undecided'
  end

  def proposal_voted
    @proposal_user ? @proposal_user.voted : false
  end

  def proposal_user_id
    @proposal_user ? @proposal_user.id : 0
  end

  def proposal_score
    up_votes = ProposalUser.all.where(proposal_id: id,
                                      evaluation: 'support').count
    down_votes = ProposalUser.all.where(proposal_id: id,
                                        evaluation: 'reject').count
    { up: up_votes, down: down_votes }
  end

  def format_pro_cons
    result = []
    pro_cons.each do |pro_con|
      result.push pro_con.as_json.merge user_name: pro_con.author_name
    end
    result
  end
end
