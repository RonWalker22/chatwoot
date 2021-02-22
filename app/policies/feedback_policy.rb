class FeedbackPolicy < ApplicationPolicy
  def update?
    own_record || @account_user.administrator?
  end

  def create?
    @account_user.agent? || @account_user.administrator?
  end

  def destroy?
    own_record || @account_user.administrator?
  end

  def bulk_destroy?
    @account_user.administrator?
  end

  def bulk_update?
    @account_user.administrator?
  end

  private

  def own_record
    requester_type = @record.requester_type
    requester_type == 'FeedbackUser' && @user.id == @record.requester.user_id
  end
end
