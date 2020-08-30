# == Schema Information
#
# Table name: clarification_posts
#
#  id                      :bigint           not null, primary key
#  body                    :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  clarification_thread_id :bigint           not null
#  feedback_contact_id     :bigint           not null
#
# Indexes
#
#  index_clarification_posts_on_clarification_thread_id  (clarification_thread_id)
#  index_clarification_posts_on_feedback_contact_id      (feedback_contact_id)
#
# Foreign Keys
#
#  fk_rails_...  (clarification_thread_id => clarification_threads.id)
#  fk_rails_...  (feedback_contact_id => feedback_contacts.id)
#
class ClarificationPost < ApplicationRecord
  belongs_to :feedback_contact
  belongs_to :clarification_thread
end
