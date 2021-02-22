class ProposalUserPolicy < ApplicationPolicy
  def create?
    @account_user.agent? || @account_user.administrator?
  end

  def update?
    return false unless review_status

    own_record || @account_user.administrator?
  end

  def destroy?
    own_record || @account_user.administrator?
  end

  private

  def own_record
    @user.id == @record.user_id
  end

  def review_status
    @record.proposal.feedback.status == 'review'
  end
end
