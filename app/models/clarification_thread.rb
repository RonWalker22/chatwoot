# == Schema Information
#
# Table name: clarification_threads
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  feedback_id :bigint           not null
#
# Indexes
#
#  index_clarification_threads_on_feedback_id  (feedback_id)
#
# Foreign Keys
#
#  fk_rails_...  (feedback_id => feedbacks.id)
#
class ClarificationThread < ApplicationRecord
  belongs_to :feedback
  has_many :clarification_posts, dependent: :destroy
end
