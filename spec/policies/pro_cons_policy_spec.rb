require 'rails_helper'
require 'support/shared_context/fb_authorization_context'

RSpec.describe 'Pro Cons API', type: :request do
  include_context 'with fb authorization'

  let!(:proposal) { create(:proposal, feedback: feedback, user: agent, account: account) }
  let!(:pro_con) { create(:pro_con, proposal: proposal, user: agent, account: account) }

  let(:klass) { ProCon }
  let(:path_name) { 'pro_cons' }
  let(:id_target) { pro_con.id }
  let(:post_params) do
    { pro_con: { body: 'test data' }, proposal_id: proposal.id }
  end
  let(:patch_params) do
    { pro_con: { body: 'new test data' } }
  end

  it_behaves_like 'fb standard create authorization'
  it_behaves_like 'fb standard update authorization'
  it_behaves_like 'fb standard destroy authorization'
end
