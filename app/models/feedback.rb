# == Schema Information
#
# Table name: feedbacks
#
#  id                :bigint           not null, primary key
#  kind              :string           default("request"), not null
#  status            :string           default("preview"), not null
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :bigint           not null
#  feedback_group_id :bigint
#  inbox_id          :bigint           not null
#  user_id           :bigint
#
# Indexes
#
#  index_feedbacks_on_account_id         (account_id)
#  index_feedbacks_on_feedback_group_id  (feedback_group_id)
#  index_feedbacks_on_inbox_id           (inbox_id)
#  index_feedbacks_on_user_id            (user_id)
#
class Feedback < ApplicationRecord
  STATUS_OPTIONS = %w[preview
                      upcoming
                      review
                      accept
                      reject].freeze
  validates :status, inclusion: { in: STATUS_OPTIONS }
  validates :title, presence: true, allow_blank: false

  belongs_to :user, optional: true
  has_many :feedback_users, dependent: :destroy
  belongs_to :inbox
  belongs_to :account
  has_many :proposals, dependent: :destroy
  has_one :clarification_thread, dependent: :destroy
  has_many :clarification_posts, through: :clarification_thread

  after_create :create_thread

  def requester_name
    user ? user.available_name : ''
  end

  private

  def create_thread
    ClarificationThread.create feedback: self, account: account
  end
end
