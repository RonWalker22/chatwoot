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
  EVALUATION_OPTIONS = %w[reject
                          support
                          undecided].freeze
  validates :evaluation, inclusion: { in: EVALUATION_OPTIONS }
  belongs_to :feedback
  belongs_to :user
end
