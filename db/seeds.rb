# loading installation configs
GlobalConfig.clear_cache
ConfigLoader.new.process

## Seeds productions
if Rails.env.production?
  # Setup Onboarding flow
  ::Redis::Alfred.set(::Redis::Alfred::CHATWOOT_INSTALLATION_ONBOARDING, true)
end

## Seeds for Local Development
unless Rails.env.production?
  SuperAdmin.create!(email: 'john@acme.inc', password: '123456')
  user = User.new(name: 'John', email: 'john@acme.inc', password: '123456')
  user.skip_confirmation!
  user.save!

  account = Account.create!(
    name: 'Acme Inc',
    domain: 'support.chatwoot.com',
    support_email: ENV.fetch('MAILER_SENDER_EMAIL', 'accounts@chatwoot.com')
  )

  AccountUser.create!(
    account_id: account.id,
    user_id: user.id,
    role: :administrator
  )

  web_widget = Channel::WebWidget.create!(account: account, website_url: 'https://acme.inc')

  inbox = Inbox.create!(channel: web_widget, account: account, name: 'Acme Support')
  InboxMember.create!(user: user, inbox: inbox)

  contact = Contact.create!(name: 'jane', email: 'jane@example.com', phone_number: '0000', account: account)
  contact_inbox = ContactInbox.create!(inbox: inbox, contact: contact, source_id: user.id, hmac_verified: true)
  conversation = Conversation.create!(
    account: account,
    inbox: inbox,
    status: :open,
    assignee: user,
    contact: contact,
    contact_inbox: contact_inbox,
    additional_attributes: {}
  )

  # sample email collect
  WootMessageSeeder.create_sample_email_collect_message conversation

  Message.create!(content: 'Hello', account: account, inbox: inbox, conversation: conversation, message_type: :incoming)

  # sample card
  WootMessageSeeder.create_sample_cards_message conversation
  # input select
  WootMessageSeeder.create_sample_input_select_message conversation
  # form
  WootMessageSeeder.create_sample_form_message conversation
  # articles
  WootMessageSeeder.create_sample_articles_message conversation

  CannedResponse.create!(account: account, short_code: 'start', content: 'Hello welcome to chatwoot.')

  agent_one = User.new(name: 'Bob', email: 'bob@acme.inc', password: '123456')
  agent_one.skip_confirmation!
  agent_one.save!

  AccountUser.create!(
    account_id: account.id,
    user_id: agent_one.id,
    role: :agent
  )

  InboxMember.create!(user_id: agent_one.id, inbox: inbox)

  # - + - feedback one - + -

  feedback_one = Feedback.create!(
    title: 'Hide vote results during the review phase',
    inbox_id: inbox.id,
    account_id: account.id,
    status: 'review',
    user_id: user.id
  )

  FeedbackUser.create!(
    feedback: feedback_one,
    user: user,
    evaluation: 'support'
  )

  Proposal.create!(
    user_id: user.id,
    feedback: feedback_one,
    account_id: account.id,
    details: 'During the review process, agents may be negatively influenced by
    the current vote results of the feedback items and solutions. Traditional
    survey questions do not come with a real-time popularity score that
    participants view before they complete each answer. Vote totals may
    interfere with honest feedback.',
    primary: false,
    solution: false
  )

  proposal_two = Proposal.create!(
    user_id: user.id,
    feedback: feedback_one,
    account_id: account.id,
    details: 'For agents, hide the vote details until after the review phase.
    For admins, hide the vote details until they evaluate the feedback and
    solutions.',
    primary: true,
    solution: true
  )

  ProposalUser.create!(
    proposal: proposal_two,
    user: user,
    voted: true,
    evaluation: 'support'
  )

  ProCon.create!(
    body: "This gives admins the opportunity to provide their initial opinions
    without being influenced by the early votes.",
    pro: true,
    user: user,
    proposal: proposal_two,
    account: account
  )

  ProCon.create!(
    body: "Because everyone can change their votes, the admins are not entirely
    out of the influence of the early votes. ",
    pro: false,
    user: user,
    proposal: proposal_two,
    account: account
  )

  proposal_three = Proposal.create!(
    user_id: user.id,
    feedback: feedback_one,
    account_id: account.id,
    details: 'Hide vote details during the review phase',
    primary: false,
    solution: true
  )

  ProposalUser.create!(
    proposal: proposal_three,
    user: user,
    voted: true,
    evaluation: 'reject'
  )

  ProCon.create!(
    body: "This would hide the total number of votes from admins. Admins use
    the vote details to know when to end the review phase.",
    pro: false,
    user: user,
    proposal: proposal_three,
    account: account
  )

  proposal_four = Proposal.create!(
    user_id: user.id,
    feedback: feedback_one,
    account_id: account.id,
    details: 'Hide the vote results from agents until the feedback item
    finishes the review phase. Allow the admins to view everything.',
    primary: false,
    solution: true
  )

  ProposalUser.create!(
    proposal: proposal_four,
    user: user,
    voted: true,
    evaluation: 'reject'
  )

  ProCon.create!(
    body: "This solution assumes we only want opinions from agents. Admins, who
    will also be sharing their opinions, are not immune from the influence of
    the early votes.",
    pro: false,
    user: user,
    proposal: proposal_four,
    account: account
  )

  ClarificationPost.create!(
    user: user,
    account: account,
    body: Faker::Lorem.paragraph(sentence_count: 3),
    proposal: proposal_two
  )
  # - + - feedback one - + -

  # - + - feedback two - + -

  feedback_two = Feedback.create!(
    title: 'Clear form input data on cancel/exit of new feedback',
    inbox_id: inbox.id,
    account_id: account.id,
    status: 'review',
    user_id: user.id
  )

  FeedbackUser.create!(
    feedback: feedback_two,
    user: user,
    evaluation: 'support'
  )

  Proposal.create!(
    user_id: user.id,
    feedback: feedback_two,
    account_id: account.id,
    details: 'When an agent/admin starts and cancels a new feedback item and
    later returns to enter a new feedback item, the old input data is still
    present. The agent/admin has to go through an additional step of removing
    the old data before providing the new data.',
    primary: false,
    solution: false
  )

  proposal_two = Proposal.create!(
    user_id: user.id,
    feedback: feedback_two,
    account_id: account.id,
    details: 'Never clear form input data on cancel/exit of new feedback.
    Instead, explicitly reset/clear form input data with a “Clear Form” button.
    ',
    primary: true,
    solution: true
  )

  ProposalUser.create!(
    proposal: proposal_two,
    user: user,
    voted: true,
    evaluation: 'support'
  )

  ProCon.create!(
    body: 'Users who accidentally click away from the form will not be affected.
    ',
    pro: true,
    user: user,
    proposal: proposal_two,
    account: account
  )

  ProCon.create!(
    body: 'Maintains UX consistency for all three ways of canceling a new
    feedback item.',
    pro: true,
    user: user,
    proposal: proposal_two,
    account: account
  )

  proposal_three = Proposal.create!(
    user_id: user.id,
    feedback: feedback_two,
    account_id: account.id,
    details: 'Clear form input data on cancel of new feedback items.',
    primary: false,
    solution: true
  )

  ProposalUser.create!(
    proposal: proposal_three,
    user: user,
    voted: true,
    evaluation: 'reject'
  )

  ProCon.create!(
    body: 'While creating a new feedback item, if a user clicks away from the
    form, the new feedback item is canceled. Because some users may do this
    accidentally, resetting the data in the case may cause unnecessary
    frustration.',
    pro: false,
    user: user,
    proposal: proposal_three,
    account: account
  )

  proposal_four = Proposal.create!(
    user_id: user.id,
    feedback: feedback_two,
    account_id: account.id,
    details: 'Clear form input data on cancel of new feedback items. But only
    do this when the user clicks the cancel icon(top right) or cancel button
    (bottom left).',
    primary: false,
    solution: true
  )

  ProposalUser.create!(
    proposal: proposal_four,
    user: user,
    voted: true,
    evaluation: 'reject'
  )

  ProCon.create!(
    body: 'Breaks consistency. Users who click away from the form may expect
    the same forgiveness when canceling a form with the icon or button.',
    pro: false,
    user: user,
    proposal: proposal_four,
    account: account
  )

  ProCon.create!(
    body: 'Users who accidentally click away from the form will not be affected.
    ',
    pro: true,
    user: user,
    proposal: proposal_four,
    account: account
  )
  # - + - feedback two - + -
end
