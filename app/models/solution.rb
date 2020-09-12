# == Schema Information
#
# Table name: solutions
#
#  id                  :bigint           not null, primary key
#  details             :text             not null
#  primary             :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  feedback_contact_id :bigint           not null
#
# Indexes
#
#  index_solutions_on_feedback_contact_id  (feedback_contact_id)
#
# Foreign Keys
#
#  fk_rails_...  (feedback_contact_id => feedback_contacts.id)
#
class Solution < ApplicationRecord
  validates :details, presence: true, allow_blank: false
  belongs_to :feedback_contact
  has_one :contact, through: :feedback_contact
  has_many :problem_solutions, dependent: :destroy
  has_many :problems, through: :problem_solutions
end