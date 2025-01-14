class Api::V1::Accounts::ProposalsController < Api::V1::Accounts::BaseController
  before_action :set_proposal, only: [:destroy, :update]
  before_action :check_authorization
  before_action :set_feedback, only: [:create]

  def create
    ActiveRecord::Base.transaction do
      proposal = Current.account.proposals.new(proposal_params)
      proposal.user = Current.user
      proposal.feedback = @feedback
      proposal.primary = false
      proposal.save!
      ProposalUser.create(user: Current.user, proposal: proposal)

      render json: proposal.as_json.merge(proposal.extra_details)
    end
  end

  def destroy
    id = @proposal.id
    feedback_id = @proposal.feedback.display_id
    @proposal.destroy
    render json: {
      feedback_id: feedback_id,
      id: id
    }
  end

  def update
    @proposal.update!(proposal_params)
    render json: { id: @proposal.id,
                   primary: @proposal.primary,
                   feedback_id: @proposal.feedback.display_id }
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      message: e.record.errors.full_messages.join(', ')
    }, status: :unprocessable_entity
  end

  private

  def set_proposal
    @proposal = Current.account.proposals.find(params[:id])
  end

  def proposal_params
    params.require(:proposal).permit(:details,
                                     :primary,
                                     :solution)
  end

  def set_feedback
    @feedback = Current.account.feedbacks.find_by(
      display_id: params[:feedback_id]
    )
  end

  def check_authorization
    authorize(@proposal || Proposal)
  end
end
