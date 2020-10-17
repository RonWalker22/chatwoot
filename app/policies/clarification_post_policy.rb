class ClarificationPostPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    true
  end

  def update?
    own_record || @account_user.administrator?
  end

  def destroy?
    own_record || @account_user.administrator?
  end

  private

  def own_record
    @user.clarification_posts.pluck(:id).include?(@record.id)
  end
end
