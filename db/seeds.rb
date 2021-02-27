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

  # - + - feedback - + -

  feedback_one = Feedback.create!(
    title: 'Hide vote results during the review phase',
    inbox_id: inbox.id,
    account_id: account.id,
    status: 'review',
    user_id: user.id
  )

  FeedbackUser.create!(
    feedback: feedback_one,
    user: user
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
    primary: false,
    solution: true
  )

  ProposalUser.create!(
    proposal: proposal_two,
    user: user,
    voted: false
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
    user: user
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
    finishes the review phase. Allow the admins to view everything. ',
    primary: false,
    solution: true
  )

  ProposalUser.create!(
    proposal: proposal_four,
    user: user
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

  ClarificationPost.create(
    user: user,
    account: account,
    body: Faker::Lorem.paragraph(sentence_count: 3),
    proposal: proposal_three
  )
  # - + - feedback - + -
end
