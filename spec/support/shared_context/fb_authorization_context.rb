RSpec.shared_context 'with fb authorization',
                     shared_context: :metadata do
  let(:account) { create(:account) }
  let(:inbox) { create(:inbox, account: account) }
  let(:account_two) { create(:account) }
  let(:agent) { create(:user, account: account, role: :agent, name: 'red one') }
  let(:agent_two) { create(:user, account: account, role: :agent, name: 'red two') }
  let(:feedback) { create(:feedback, account: account) }
  let(:feedback_user) do
    create(:feedback_user, feedback: feedback, user: agent)
  end
  let(:feedback_two) { create(:feedback, account: account) }
  let(:administrator) do
    create(
      :user,
      account: account,
      role: :administrator
    )
  end
  let(:unrelated_admin) do
    create(
      :user,
      account: account_two,
      role: :administrator
    )
  end
end
