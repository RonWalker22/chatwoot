# == Schema Information
#
# Table name: proposal_users
#
#  id          :bigint           not null, primary key
#  evaluation  :string           default("undecided"), not null
#  voted       :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  proposal_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_proposal_user_uniqueness       (proposal_id,user_id) UNIQUE
#  index_proposal_users_on_proposal_id  (proposal_id)
#  index_proposal_users_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (proposal_id => proposals.id)
#  fk_rails_...  (user_id => users.id)
#
class ProposalUser < ApplicationRecord
  belongs_to :proposal
  belongs_to :user
end
