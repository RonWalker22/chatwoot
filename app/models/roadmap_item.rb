# == Schema Information
#
# Table name: roadmap_items
#
#  id          :bigint           not null, primary key
#  body        :text
#  due_by      :date
#  status      :string           default("later"), not null
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  feedback_id :bigint
#
# Indexes
#
#  index_roadmap_items_on_feedback_id  (feedback_id)
#
# Foreign Keys
#
#  fk_rails_...  (feedback_id => feedbacks.id)
#
class RoadmapItem < ApplicationRecord
  belongs_to :feedback, optional: true
  has_one :roadmap_group_item, dependent: :destroy
  has_one :roadmap_group, through: :roadmap_group_item
end
