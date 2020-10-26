class ProposalPolicy < ApplicationPolicy
  def update?
    own_record || @account_user.administrator?
  end

  def destroy?
    own_record || @account_user.administrator?
  end

  private

  def own_record
    !user_proposal && @user.id == @record.proposer.user_id
  end

  def user_proposal
    @record.proposer_type == 'FeedbackContact'
  end
end
