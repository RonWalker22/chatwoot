# == Schema Information
#
# Table name: feedback_groups
#
#  id         :bigint           not null, primary key
#  active     :boolean
#  priority   :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class FeedbackGroup < ApplicationRecord
  has_many :feedbacks, dependent: :destroy
end
