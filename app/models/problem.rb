# == Schema Information
#
# Table name: problems
#
#  id            :bigint           not null, primary key
#  details       :text             not null
#  primary       :boolean          default(FALSE), not null
#  proposer_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  feedback_id   :bigint           not null
#  proposer_id   :bigint           not null
#
# Indexes
#
#  index_problems_on_feedback_id                    (feedback_id)
#  index_problems_on_proposer_type_and_proposer_id  (proposer_type,proposer_id)
#
class Problem < ApplicationRecord
  validates :details, presence: true, allow_blank: false
  belongs_to :proposer, polymorphic: true
  belongs_to :feedback
  has_many :problem_solutions, dependent: :destroy
  has_many :solutions, through: :problem_solutions

  def proposer_name
    proposer_type == 'FeedbackContact' ? proposer.contact.name : proposer.user.name
  end
end
