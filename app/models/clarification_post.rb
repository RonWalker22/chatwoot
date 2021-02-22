# == Schema Information
#
# Table name: clarification_posts
#
#  id                      :bigint           not null, primary key
#  body                    :text             not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  account_id              :bigint           not null
#  clarification_thread_id :bigint           not null
#  user_id                 :bigint
#
# Indexes
#
#  index_clarification_posts_on_account_id               (account_id)
#  index_clarification_posts_on_clarification_thread_id  (clarification_thread_id)
#  index_clarification_posts_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (clarification_thread_id => clarification_threads.id)
#
class ClarificationPost < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :account
  belongs_to :clarification_thread

  def author_name
    user ? user.available_name : ''
  end
end
