require 'rails_helper'
require 'support/shared_context/fb_authorization_context'

RSpec.describe 'Proposals API', type: :request do
  include_context 'with fb authorization'
  let!(:proposal) do
    create(:proposal, feedback: feedback, user: agent, account: account)
  end

  let(:klass) { Proposal }
  let(:path_name) { 'proposals' }
  let(:id_target) { proposal.id }
  let(:post_params) do
    { proposal: { details: 'test data', feedback_id: feedback.id } }
  end
  let(:patch_params) do
    { proposal: { details: 'new test data' } }
  end

  it_behaves_like 'fb standard create authorization'
  it_behaves_like 'fb standard update authorization'
  it_behaves_like 'fb standard destroy authorization'
end
