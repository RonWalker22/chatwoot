class Api::V1::Accounts::ProposalsController < Api::V1::Accounts::BaseController
  before_action :set_proposal, only: [:destroy]
  before_action :check_authorization, except: [:create]
  before_action :set_feedback, only: [:create]
  before_action :find_feedback_user, only: [:create]

  def create
    proposal = Proposal.new(proposal_params)
    proposal.proposer = @feedback_user
    proposal.solution = true
    proposal.primary = false

    if proposal.save
      render json: {
        details: proposal.details,
        proposer: proposal.proposer_name,
        id: proposal.id,
        feedback_id: proposal.feedback_id,
        date: proposal.created_at.to_date,
        solution: proposal.solution
      }
    else
      render json: proposal.errors, status: :unprocessable_entity
    end
  end

  def destroy
    id = @proposal.id
    feedback_id = @proposal.feedback_id
    @proposal.destroy
    render json: {
      feedback_id: feedback_id,
      id: id
    }
  end

  private

  def set_proposal
    @proposal = Proposal.find(params[:id])
  end

  def proposal_params
    params.require(:proposal).permit(:details, :feedback_id)
  end

  def set_feedback
    @feedback = Current.account.feedbacks.find(proposal_params[:feedback_id])
  end

  def create_feedback_user
    @feedback_user = FeedbackUser.create user: Current.user,
                                         feedback: @feedback
  end

  def find_feedback_user
    @feedback_user = FeedbackUser.find_by user: Current.user,
                                          feedback: @feedback
    @feedback_user || create_feedback_user
  end

  def check_authorization
    authorize(@proposal)
  end
end
