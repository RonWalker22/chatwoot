class Api::V1::Accounts::ProposalsController < Api::V1::Accounts::BaseController
  before_action :set_proposal, only: [:destroy, :update]
  before_action :check_authorization, except: [:create]
  before_action :set_feedback, only: [:create]
  before_action :find_feedback_user, only: [:create]

  def create
    proposal = Proposal.new(proposal_params)
    proposal.proposer = @feedback_user
    proposal.primary = false

    if proposal.save
      render json: proposal.as_json.merge(proposal.extra_details)
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

  def update
    @proposal.update!(proposal_params)
    render json: { id: @proposal.id,
                   primary: @proposal.primary,
                   feedback_id: @proposal.feedback_id }
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      message: e.record.errors.full_messages.join(', ')
    }, status: :unprocessable_entity
  end

  private

  def set_proposal
    @proposal = Proposal.find(params[:id])
  end

  def proposal_params
    params.require(:proposal).permit(:details,
                                     :feedback_id,
                                     :primary,
                                     :solution)
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
