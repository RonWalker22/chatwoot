require 'rails_helper'

RSpec.describe 'Feedbacks API', type: :request do
  include_context 'with fb authorization'

  let!(:ids) { [feedback.display_id, feedback_two.display_id] }

  let(:klass) { Feedback }
  let(:path_name) { 'feedbacks' }
  let(:id_target) { feedback.display_id }
  let(:post_params) do
    { feedback: { title: 'love',
                  inbox_id: inbox.id,
                  account_id: account.id } }
  end
  let(:bulk_patch_params) do
    { ids: [ids.first, ids.second],
      feedback: { title: 'new test data' } }
  end

  it_behaves_like 'fb standard index authorization'
  it_behaves_like 'fb standard show authorization'
  it_behaves_like 'fb standard create authorization'
  it_behaves_like 'fb bulk destroy authorization'
  it_behaves_like 'fb bulk update authorization'
end
