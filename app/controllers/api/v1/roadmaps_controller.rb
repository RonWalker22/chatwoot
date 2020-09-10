class Api::V1::RoadmapsController < Api::V1::Widget::BaseController
  skip_before_action :set_contact

  def index
    @groups = @web_widget.roadmap_groups.includes(:roadmap_items).where.not(status: 'complete')

    set_group_items
  end

  private

  def permitted_params
    params.permit(:website_token, :identifier)
  end

  def set_group_items
    @now_groups = []
    @next_groups = []
    @later_groups = []

    @groups.each do |group|
      case group.status
      when 'now'
        @now_groups << { group: group, items: group.roadmap_items }
      when 'next'
        @next_groups << { group: group, items: group.roadmap_items }
      when 'later'
        @later_groups << { group: group, items: group.roadmap_items }
      end
    end
  end
end
