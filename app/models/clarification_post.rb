# == Schema Information
#
# Table name: clarification_posts
#
#  id          :bigint           not null, primary key
#  body        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#  proposal_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_clarification_posts_on_account_id   (account_id)
#  index_clarification_posts_on_proposal_id  (proposal_id)
#  index_clarification_posts_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (proposal_id => proposals.id)
#  fk_rails_...  (user_id => users.id)
#
class ClarificationPost < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :account
  belongs_to :proposal

  def author_name
    user ? user.available_name : ''
  end
end
