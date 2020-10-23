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
#  index_feedback_contacts_on_contact_id                  (contact_id)
#  index_feedback_contacts_on_feedback_id                 (feedback_id)
#  index_feedback_contacts_on_feedback_id_and_contact_id  (feedback_id,contact_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (contact_id => contacts.id)
#  fk_rails_...  (feedback_id => feedbacks.id)
#
class FeedbackContact < ApplicationRecord
  belongs_to :feedback
  belongs_to :contact
  has_many :clarification_posts, as: :author, dependent: :destroy
  has_many :feedbacks, as: :requester, dependent: :destroy
  has_many :proposals, as: :proposer, dependent: :destroy
end
