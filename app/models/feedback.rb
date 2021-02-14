# == Schema Information
#
# Table name: feedbacks
#
#  id                :bigint           not null, primary key
#  funding_goal      :integer          default(0)
#  kind              :string           default("request"), not null
#  requester_type    :string
#  status            :string           default("review"), not null
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :bigint           not null
#  feedback_group_id :bigint
#  inbox_id          :bigint           not null
#  requester_id      :bigint
#
# Indexes
#
#  index_feedbacks_on_account_id                       (account_id)
#  index_feedbacks_on_feedback_group_id                (feedback_group_id)
#  index_feedbacks_on_inbox_id                         (inbox_id)
#  index_feedbacks_on_requester_type_and_requester_id  (requester_type,requester_id)
#
class Feedback < ApplicationRecord
  STATUS_OPTIONS = %w[review
                      upcoming
                      reject
                      accept
                      active
                      preview
                      now
                      next
                      later
                      done
                      completed].freeze
  validates :status, inclusion: { in: STATUS_OPTIONS }
  validates :title, presence: true, allow_blank: false

  has_one :roadmap_item, dependent: :destroy
  belongs_to :requester, polymorphic: true, optional: true
  belongs_to :feedback_group, optional: true
  has_many :feedback_contacts, dependent: :destroy
  has_many :feedback_users, dependent: :destroy
  has_many :supporters, through: :feedback_contacts, source: :contact
  belongs_to :inbox
  belongs_to :account
  has_many :proposals, dependent: :destroy
  has_many :user_proposals, through: :feedback_users, source: :proposals
  has_many :contact_proposals, through: :feedback_contacts, source: :proposals
  has_one :clarification_thread, dependent: :destroy
  has_many :clarification_posts, through: :clarification_thread

  after_create :create_thread
  after_create :create_requester

  def requester_name
    requester_type == 'FeedbackContact' ? requester.contact.name : requester.user.name
  end

  private

  def create_thread
    ClarificationThread.create feedback: self
  end

  def create_requester
    @feedback_user = FeedbackUser.create user: Current.user, feedback: self
    self.requester = @feedback_user
    save!
  end
end
