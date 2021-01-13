# == Schema Information
#
# Table name: pro_cons
#
#  id               :bigint           not null, primary key
#  body             :text             not null
#  pro              :boolean          default(TRUE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  proposal_user_id :bigint           not null
#
# Indexes
#
#  index_pro_cons_on_proposal_user_id  (proposal_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (proposal_user_id => proposal_users.id)
#
class ProCon < ApplicationRecord
  belongs_to :proposal_user
  has_one :user, through: :proposal_user
  has_one :proposal, through: :proposal_user
end
