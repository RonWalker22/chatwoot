# == Schema Information
#
# Table name: roadmap_groups
#
#  id         :bigint           not null, primary key
#  body       :text
#  due_by     :date
#  status     :string           default("later"), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#  inbox_id   :bigint           not null
#
# Indexes
#
#  index_roadmap_groups_on_account_id  (account_id)
#  index_roadmap_groups_on_inbox_id    (inbox_id)
#
class RoadmapGroup < ApplicationRecord
  belongs_to :inbox
  belongs_to :account
  has_many :roadmap_group_items, dependent: :destroy
  has_many :roadmap_items, through: :roadmap_group_items
end
