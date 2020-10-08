# == Schema Information
#
# Table name: feedbacks
#
#  id           :bigint           not null, primary key
#  funding_goal :integer          default(0)
#  status       :string           default("review"), not null
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :bigint           not null
#  inbox_id     :bigint           not null
#  requester_id :bigint           not null
#
# Indexes
#
#  index_feedbacks_on_account_id    (account_id)
#  index_feedbacks_on_inbox_id      (inbox_id)
#  index_feedbacks_on_requester_id  (requester_id)
#
# Foreign Keys
#
#  fk_rails_...  (requester_id => contacts.id)
#
class Feedback < ApplicationRecord
  STATUS_OPTIONS = %w[review
                      rejected
                      active
                      campaign
                      now
                      next
                      later
                      completed].freeze
  validates :status, inclusion: { in: STATUS_OPTIONS }
  validates :title, presence: true, allow_blank: false

  has_one :roadmap_item, dependent: :destroy
  belongs_to :requester, class_name: 'Contact'
  has_many :feedback_contacts, dependent: :destroy
  has_many :supporters, through: :feedback_contacts, source: :contact
  belongs_to :inbox
  belongs_to :account
  has_many :problems, through: :feedback_contacts
  has_many :solutions, through: :feedback_contacts
  has_one :clarification_thread, dependent: :destroy
  has_many :clarification_posts, through: :clarification_thread
  after_create :create_thread

  private

  def create_thread
    ClarificationThread.create feedback: self
  end
end
