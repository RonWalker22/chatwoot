# == Schema Information
#
# Table name: feedback_users
#
#  id          :bigint           not null, primary key
#  evaluation  :string           default("undecided"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  feedback_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_feedback_users_on_feedback_id              (feedback_id)
#  index_feedback_users_on_feedback_id_and_user_id  (feedback_id,user_id) UNIQUE
#  index_feedback_users_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (feedback_id => feedbacks.id)
#  fk_rails_...  (user_id => users.id)
#
class FeedbackUser < ApplicationRecord
  belongs_to :feedback
  belongs_to :user
  has_many :proposals, as: :proposer, dependent: :destroy
  has_many :clarification_posts, as: :author, dependent: :destroy
  has_many :feedbacks, as: :proposer, dependent: :destroy
end
