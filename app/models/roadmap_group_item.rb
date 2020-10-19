# == Schema Information
#
# Table name: roadmap_group_items
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  roadmap_group_id :bigint           not null
#  roadmap_item_id  :bigint           not null
#
# Indexes
#
#  index_roadmap_group_items_on_roadmap_group_id  (roadmap_group_id)
#  index_roadmap_group_items_on_roadmap_item_id   (roadmap_item_id)
#  roadmap_item_roadmap_group_index               (roadmap_item_id,roadmap_group_id) UNIQUE
#
class RoadmapGroupItem < ApplicationRecord
  belongs_to :roadmap_group
  belongs_to :roadmap_item
end
