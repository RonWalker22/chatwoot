class Api::V1::Accounts::ProConsController < Api::V1::Accounts::BaseController
  before_action :set_pro_con, only: [:destroy, :update]
  before_action :check_authorization
  before_action :find_proposal, only: [:create]

  def create
    pro_con = Current.account.pro_cons.new(pro_con_params)
    pro_con.user = Current.user
    pro_con.proposal = @proposal
    pro_con.save!

    render json: { id: pro_con.id,
                   pro_con: pro_con.as_json.merge(
                     user_name: pro_con.author_name
                   ),
                   feedback_id: pro_con.proposal.feedback.display_id,
                   proposal_id: pro_con.proposal.id }
  end

  def destroy
    id = @pro_con.id
    feedback_id = @pro_con.proposal.feedback.display_id
    proposal_id = @pro_con.proposal.id
    if @pro_con.destroy
      render json: {
        feedback_id: feedback_id,
        id: id,
        proposal_id: proposal_id
      }
    else
      render json: @pro_con.errors, status: :unprocessable_entity
    end
  end

  def update
    @pro_con.update!(pro_con_params)
    render json: { id: @pro_con.id,
                   pro: @pro_con.pro,
                   feedback_id: @pro_con.proposal.feedback.display_id,
                   proposal_id: @pro_con.proposal.id }
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      message: e.record.errors.full_messages.join(', ')
    }, status: :unprocessable_entity
  end

  private

  def set_pro_con
    @pro_con = Current.account.pro_cons.find(params[:id])
  end

  def pro_con_params
    params.require(:pro_con).permit(:body, :pro, :id)
  end

  def find_proposal
    @proposal = Current.account.proposals.find(params[:proposal_id])
  end

  def check_authorization
    authorize(@pro_con || ProCon)
  end
end
