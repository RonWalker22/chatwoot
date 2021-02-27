# == Schema Information
#
# Table name: pro_cons
#
#  id          :bigint           not null, primary key
#  body        :text             not null
#  pro         :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#  proposal_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_pro_cons_on_account_id   (account_id)
#  index_pro_cons_on_proposal_id  (proposal_id)
#  index_pro_cons_on_user_id      (user_id)
#
class ProCon < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :proposal
  belongs_to :account

  def author_name
    user ? user.available_name : ''
  end
end
