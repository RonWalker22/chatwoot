require 'rails_helper'
require 'support/shared_context/fb_authorization_context'

RSpec.describe 'Clarification Posts API', type: :request do
  include_context 'with fb authorization'
  let!(:proposal) do
    create(:proposal, feedback: feedback, user: agent, account: account)
  end
  let!(:clarification_post) do
    create(:clarification_post,
           user: agent,
           proposal: proposal,
           account: account)
  end

  let(:klass) { ClarificationPost }
  let(:path_name) { 'clarification_posts' }
  let(:id_target) { clarification_post.id }
  let(:post_params) do
    { clarification_post: { body: 'test data',
                            proposal_id: proposal.id } }
  end
  let(:patch_params) do
    { clarification_post: { body: 'new test data' } }
  end

  it_behaves_like 'fb standard create authorization'
  it_behaves_like 'fb standard destroy authorization'
end
