require 'rails_helper'
require 'support/shared_context/fb_authorization_context'

RSpec.describe 'Proposal User API', type: :request do
  include_context 'with fb authorization'
  let!(:proposal) do
    create(:proposal, feedback: feedback, user: agent, account: account)
  end

  let(:klass) { ProposalUser }
  let(:path_name) { 'proposal_users' }

  it_behaves_like 'fb standard update authorization' do
    let!(:proposal_user) do
      create(:proposal_user,
             user: agent,
             proposal: proposal)
    end
    let(:patch_params) do
      { proposal_user: { evaluation: 'support' }, proposal_id: proposal.id }
    end
    let(:id_target) { proposal_user.id }
  end

  it_behaves_like 'fb standard create authorization' do
    let(:post_params) { { proposal_id: proposal.id } }
  end
end
