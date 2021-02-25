require 'rails_helper'

RSpec.describe 'Feedbacks API', type: :request do
  include_context 'with fb authorization'
  let(:klass) { FeedbackUser }
  let(:path_name) { 'feedback_users' }

  it_behaves_like 'fb standard create authorization' do
    let(:post_params) do
      { feedback_id: feedback.display_id }
    end
  end

  it_behaves_like 'fb standard update authorization' do
    let!(:feedback_user) do
      create(:feedback_user, feedback: feedback, user: agent)
    end
    let(:patch_params) do
      { feedback_user: { evaluation: 'support' },
        feedback_id: feedback.display_id }
    end
    let(:id_target) { feedback_user.id }
  end
end
