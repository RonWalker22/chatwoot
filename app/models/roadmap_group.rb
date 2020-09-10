# == Schema Information
#
# Table name: roadmap_groups
#
#  id            :bigint           not null, primary key
#  body          :text
#  due_by        :date
#  status        :string           default("later"), not null
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  web_widget_id :bigint
#
# Indexes
#
#  index_roadmap_groups_on_web_widget_id  (web_widget_id)
#
class RoadmapGroup < ApplicationRecord
  belongs_to :web_widget, class_name: '::Channel::WebWidget'
  has_many :roadmap_group_items, dependent: :destroy
  has_many :roadmap_items, through: :roadmap_group_items
end
