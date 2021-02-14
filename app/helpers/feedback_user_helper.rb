module FeedbackUserHelper
  def feedback_user_evaluation(feedback_users)
    feedback_users.pluck(:user_id, :evaluation).each do |feedback_user|
      return feedback_user[1] if feedback_user[0] == Current.user.id
    end
    'undecided'
  end
end
