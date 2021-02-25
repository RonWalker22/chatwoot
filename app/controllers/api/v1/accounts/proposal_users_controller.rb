class Api::V1::Accounts::ProposalUsersController < Api::V1::Accounts::BaseController
  before_action :set_proposal
  before_action :set_proposal_user, only: [:update]
  before_action :check_authorization

  def create
    proposal_user = ProposalUser.new(proposal_user_params)
    proposal_user.user = Current.user
    proposal_user.proposal = @proposal

    if proposal_user.save
      render json: {
        evaluation: proposal_user.evaluation,
        feedback_id: proposal_user.proposal.feedback.display_id,
        proposal_user_id: proposal_user.id,
        proposal_id: proposal_user.proposal.id,
        id: proposal_user.proposal.id,
        voted: proposal_user.voted
      }
    else
      render json: proposal_user.errors, status: :unprocessable_entity
    end
  end

  def update
    @proposal_user.update!(proposal_user_params)
    render json: {
      evaluation: @proposal_user.evaluation,
      feedback_id: @proposal_user.proposal.feedback.display_id,
      proposal_user_id: @proposal_user.id,
      proposal_id: @proposal_user.proposal.id,
      id: @proposal_user.proposal.id,
      voted: @proposal_user.voted
    }
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      message: e.record.errors.full_messages.join(', ')
    }, status: :unprocessable_entity
  end

  private

  def proposal_user_params
    params.require('proposal_user').permit(:evaluation,
                                           :voted)
  end

  def set_proposal_user
    @proposal_user = ProposalUser.find_by(id: params[:id], proposal: @proposal)
  end

  def set_proposal
    @proposal = Current.account.proposals.find(params[:proposal_id])
  end

  def check_authorization
    authorize(@proposal_user || ProposalUser)
  end
end
