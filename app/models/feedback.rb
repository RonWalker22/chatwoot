# == Schema Information
#
# Table name: feedbacks
#
#  id         :bigint           not null, primary key
#  kind       :string           default("request"), not null
#  status     :string           default("preview"), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#  display_id :integer          not null
#  inbox_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_feedbacks_on_account_id                 (account_id)
#  index_feedbacks_on_account_id_and_display_id  (account_id,display_id) UNIQUE
#  index_feedbacks_on_inbox_id                   (inbox_id)
#  index_feedbacks_on_user_id                    (user_id)
#
class Feedback < ApplicationRecord
  STATUS_OPTIONS = %w[preview
                      upcoming
                      review
                      accept
                      reject].freeze
  KIND_OPTIONS = %w[bug request].freeze
  validates :status, inclusion: { in: STATUS_OPTIONS }
  validates :kind, inclusion: { in: KIND_OPTIONS }
  validates :title, presence: true, allow_blank: false

  belongs_to :user, optional: true
  has_many :feedback_users, dependent: :destroy
  belongs_to :inbox
  belongs_to :account
  has_many :proposals, dependent: :destroy
  has_many :clarification_posts, through: :proposals

  after_commit :set_display_id, unless: :display_id?

  def requester_name
    user ? user.available_name : ''
  end

  private

  def set_display_id
    reload
  end

  # creating db triggers
  trigger.before(:insert).for_each(:row) do
    "NEW.display_id := nextval('feedb_dpid_seq_' || NEW.account_id);"
  end
end
