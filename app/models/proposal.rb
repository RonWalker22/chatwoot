class Proposal < ApplicationRecord
  validates :details, presence: true, allow_blank: false
  belongs_to :proposer, polymorphic: true
  belongs_to :feedback

  def proposer_name
    proposer_type == 'FeedbackContact' ? proposer.contact.name : proposer.user.name
  end
end
