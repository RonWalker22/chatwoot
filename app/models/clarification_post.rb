# == Schema Information
#
# Table name: clarification_posts
#
#  id                      :bigint           not null, primary key
#  author_type             :string
#  body                    :text             not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  author_id               :bigint
#  clarification_thread_id :bigint           not null
#
# Indexes
#
#  index_clarification_posts_on_author_type_and_author_id  (author_type,author_id)
#  index_clarification_posts_on_clarification_thread_id    (clarification_thread_id)
#
# Foreign Keys
#
#  fk_rails_...  (clarification_thread_id => clarification_threads.id)
#
class ClarificationPost < ApplicationRecord
  belongs_to :author, polymorphic: true
  belongs_to :clarification_thread
end
