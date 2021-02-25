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
    title: 'Patreon integration - Give IK4 credit for patreon pledges',
    inbox_id: inbox.id,
    account_id: account.id,
    status: 'review',
    user_id: agent_one.id
  )
  feedback_two = Feedback.create!(
    title: 'Import feature requests from other platforms',
    inbox_id: inbox.id,
    account_id: account.id,
    status: 'review',
    user_id: agent_one.id
  )
  feedback_three = Feedback.create!(
    title: 'Support organizations with multiple products',
    inbox_id: inbox.id,
    account_id: account.id,
    status: 'review',
    user_id: agent_one.id
  )

  feedback_four = Feedback.create!(
    title: 'Hide vote results during the review phase',
    inbox_id: inbox.id,
    account_id: account.id,
    status: 'review',
    user_id: agent_one.id
  )

  FeedbackUser.create!(
    feedback: feedback_four,
    user: user,
    evaluation: 'support'
  )

  Proposal.create!(
    user_id: agent_one.id,
    feedback: feedback_one,
    account_id: account.id,
    details: "Because I have use the IK4 platform and patreon, some of my\
  supporters might transition from pledging monthly to one-time contributions.\
  I do not want to discourage any of my supporters from canceling or lowering\
  their monthly pledges.",
    primary: true,
    solution: false
  )

  Proposal.create!(
    user_id: agent_one.id,
    feedback: feedback_one,
    account_id: account.id,
    details: 'Provide patreon supporters with dollar for dollar credit for each pledge.',
    primary: true,
    solution: true
  )

  2.times do
    Proposal.create! user_id: agent_one.id,
                     feedback: feedback_one,
                     account_id: account.id,
                     details: Faker::Lorem.paragraph(sentence_count: 15),
                     primary: false,
                     solution: true

    ClarificationPost.create!(
      user_id: agent_one.id,
      account_id: account.id,
      body: Faker::Lorem.paragraph(sentence_count: 3),
      clarification_thread_id: feedback_two.clarification_thread.id
    )
  end

  Proposal.create!(
    user_id: agent_one.id,
    feedback: feedback_two,
    account_id: account.id,
    details: 'I am transitioning from another platform and have a lot of data from their that I can’t utilize.',
    primary: true,
    solution: false
  )
  Proposal.create!(
    user_id: agent_one.id,
    feedback: feedback_two,
    account_id: account.id,
    details: 'Add the ability to import feedback from other platforms.',
    primary: true,
    solution: true
  )

  Proposal.create!(
    user_id: agent_one.id,
    feedback: feedback_three,
    account_id: account.id,
    details: 'Switching between different organization accounts in order to manage multiple products is time consuming.',
    primary: true,
    solution: false
  )

  proposal_one = Proposal.create!(
    user_id: agent_one.id,
    feedback: feedback_three,
    account_id: account.id,
    details: 'Allow each organization to have multiple products and associate
    customers and feature request to individual products instead of the
    organization. This way I don’t have to sign in and out of my account to
    management multiple products that are tied to the same organization.',
    primary: true,
    solution: true
  )

  Proposal.create!(
    user_id: user.id,
    feedback: feedback_four,
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
    feedback: feedback_four,
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
    evaluation: 'support',
    voted: true
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
    feedback: feedback_four,
    account_id: account.id,
    details: 'Hide vote details during the review phase',
    primary: false,
    solution: true
  )

  ProposalUser.create!(
    proposal: proposal_three,
    user: user,
    evaluation: 'reject',
    voted: true
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
    feedback: feedback_four,
    account_id: account.id,
    details: 'Hide the vote results from agents until the feedback item
    finishes the review phase. Allow the admins to view everything. ',
    primary: false,
    solution: true
  )

  ProposalUser.create!(
    proposal: proposal_four,
    user: user,
    evaluation: 'reject',
    voted: true
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
    user_id: agent_one.id,
    account_id: account.id,
    body: Faker::Lorem.paragraph(sentence_count: 3),
    clarification_thread_id: proposal_one.clarification_thread.id
  )

  ProposalUser.create!(
    proposal: proposal_one,
    user: User.first
  )

  ProCon.create!(
    body: "Moluptatum ea quam. Voluptatem dolorem tempore. Qui itaque
    quisquam. Ad itaque atque. Iure dicta error. Illum occaecati vitae.
    Architecto adipisci corporis. Animi occaecati quod. Voluptatem reiciendis qui.
    ",
    pro: true,
    user: agent_one,
    proposal: proposal_one,
    account: account
  )

  ProCon.create!(
    body: "Toluptatum ea quam. Voluptatem dolorem tempore. Qui itaque
    quisquam. Ad itaque atque. Iure dicta error. Illum occaecati vitae.
    Architecto adipisci corporis. Animi occaecati quod. Voluptatem reiciendis qui.
    ",
    pro: false,
    user: agent_one,
    proposal: proposal_one,
    account: account
  )

  # - + - feedback - + -
end
