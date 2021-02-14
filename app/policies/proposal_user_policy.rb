class ProposalUserPolicy < ApplicationPolicy
  def create?
    @record.proposal.feedback.status == 'review'
  end

  def update?
    return false unless @record.proposal.feedback.status == 'review'

    own_record || @account_user.administrator?
  end

  def destroy?
    own_record || @account_user.administrator?
  end

  private

  def own_record
    @user.id == @record.user_id
  end
end
