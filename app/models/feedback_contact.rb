# == Schema Information
#
# Table name: feedback_contacts
#
#  id            :bigint           not null, primary key
#  prefund_level :integer          default(0), not null
#  support_level :integer          default(0), not null
#  supporter     :boolean          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  contact_id    :bigint           not null
#  feedback_id   :bigint           not null
#
# Indexes
#
#  index_feedback_contacts_on_contact_id   (contact_id)
#  index_feedback_contacts_on_feedback_id  (feedback_id)
#
# Foreign Keys
#
#  fk_rails_...  (contact_id => contacts.id)
#  fk_rails_...  (feedback_id => feedbacks.id)
#
class FeedbackContact < ApplicationRecord
  belongs_to :feedback
  belongs_to :contact
  has_many :solution, dependent: :destroy
  has_many :problems, dependent: :destroy
end
