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

  account = Account.create!(
    name: 'Acme Inc',
    domain: 'support.chatwoot.com',
    support_email: ENV.fetch('MAILER_SENDER_EMAIL', 'accounts@chatwoot.com')
  )

  user = User.new(name: 'John', email: 'john@acme.inc', password: '123456')
  user.skip_confirmation!
  user.save!

  AccountUser.create!(
    account_id: account.id,
    user_id: user.id,
    role: :administrator
  )

  web_widget = Channel::WebWidget.create!(account: account, website_url: 'https://acme.inc')

  inbox = Inbox.create!(channel: web_widget, account: account, name: 'Acme Support')
  InboxMember.create!(user: user, inbox: inbox)

  contact = Contact.create!(name: 'jane', email: 'jane@example.com', phone_number: '0000', account: account)
  contact_inbox = ContactInbox.create!(inbox: inbox, contact: contact, source_id: user.id)
  conversation = Conversation.create!(
    account: account,
    inbox: inbox,
    status: :open,
    assignee: user,
    contact: contact,
    contact_inbox: contact_inbox,
    additional_attributes: {}
  )
  Message.create!(content: 'Hello', account: account, inbox: inbox, conversation: conversation, message_type: :incoming)
  CannedResponse.create!(account: account, short_code: 'start', content: 'Hello welcome to chatwoot.')

  agent_one = User.new(name: 'Bob', email: 'bob@acme.inc', password: '123456')
  agent_one.skip_confirmation!
  agent_one.save!

  AccountUser.create!(
    account_id: account.id,
    user_id: agent_one.id,
    role: :agent
  )

  InboxMember.create!(user: agent_one, inbox: inbox)

  # - + - feedback - + -

  feedback_one = Feedback.create!(
    title: 'Patreon integration - Give IK4 credit for patreon pledges',
    funding_goal: 1000,
    inbox_id: inbox.id,
    account_id: web_widget.account.id,
    status: 'review'
  )
  feedback_two = Feedback.create!(
    title: 'Import feature requests from other platforms',
    funding_goal: 1000,
    inbox_id: inbox.id,
    account_id: web_widget.account.id,
    status: 'review'
  )
  feedback_three = Feedback.create!(
    title: 'Support organizations with multiple products',
    funding_goal: 1000,
    inbox_id: inbox.id,
    account_id: web_widget.account.id,
    status: 'review'
  )

  feedback_contact_one = FeedbackContact.create! contact_id: contact.id,
                                                 feedback_id: feedback_one.id,
                                                 support_level: 600,
                                                 prefund_level: 600,
                                                 supporter: true

  feedback_one.update(requester: feedback_contact_one)

  feedback_contact_two = FeedbackContact.create! contact_id: contact.id,
                                                 feedback_id: feedback_two.id,
                                                 support_level: 900,
                                                 prefund_level: 900,
                                                 supporter: true

  feedback_two.update(requester: feedback_contact_two)

  feedback_contact_three = FeedbackContact.create! contact_id: contact.id,
                                                   feedback_id:
                                                    feedback_three.id,
                                                   support_level: 200,
                                                   prefund_level: 200,
                                                   supporter: true

  feedback_three.update(requester: feedback_contact_three)

  Proposal.create!(
    proposer: feedback_contact_one,
    feedback: feedback_contact_one.feedback,
    details: "Because I have use the IK4 platform and patreon, some of my\
  supporters might transition from pledging monthly to one-time contributions.\
  I do not want to discourage any of my supporters from canceling or lowering\
  their monthly pledges.",
    primary: true,
    solution: false
  )

  Proposal.create!(
    proposer: feedback_contact_one,
    feedback: feedback_contact_one.feedback,
    details: 'Provide patreon supporters with dollar for dollar credit for each pledge.',
    primary: true,
    solution: true
  )

  2.times do
    Proposal.create proposer: feedback_contact_one,
                    feedback: feedback_contact_one.feedback,
                    details: Faker::Lorem.paragraph(sentence_count: 15),
                    primary: false,
                    solution: true

    ClarificationPost.create(
      author: feedback_contact_two,
      body: Faker::Lorem.paragraph(sentence_count: 3),
      clarification_thread: feedback_two.clarification_thread
    )
  end

  Proposal.create!(
    proposer: feedback_contact_two,
    feedback: feedback_contact_two.feedback,
    details: 'I am transitioning from another platform and have a lot of data from their that I can’t utilize.',
    primary: true,
    solution: false
  )
  Proposal.create!(
    proposer: feedback_contact_two,
    feedback: feedback_contact_two.feedback,
    details: 'Add the ability to import feedback from other platforms.',
    primary: true,
    solution: true
  )

  Proposal.create!(
    proposer: feedback_contact_three,
    feedback: feedback_contact_three.feedback,
    details: 'Switching between different organization accounts in order to manage multiple products is time consuming.',
    primary: true,
    solution: false
  )

  proposal_one = Proposal.create!(
    proposer: feedback_contact_three,
    feedback: feedback_contact_three.feedback,
    details: 'Allow each organization to have multiple products and associate
    customers and feature request to individual products instead of the
    organization. This way I don’t have to sign in and out of my account to
    management multiple products that are tied to the same organization.',
    primary: true,
    solution: true
  )

  ClarificationPost.create(
    author: feedback_contact_two,
    body: Faker::Lorem.paragraph(sentence_count: 3),
    clarification_thread: proposal_one.clarification_thread
  )

  proposal_user_one = ProposalUser.create(
    proposal: proposal_one,
    user: User.first
  )

  ProCon.create(
    body: "Moluptatum ea quam. Voluptatem dolorem tempore. Qui itaque
    quisquam. Ad itaque atque. Iure dicta error. Illum occaecati vitae.
    Architecto adipisci corporis. Animi occaecati quod. Voluptatem reiciendis qui.
    ",
    pro: true,
    proposal_user: proposal_user_one
  )

  ProCon.create(
    body: "Toluptatum ea quam. Voluptatem dolorem tempore. Qui itaque
    quisquam. Ad itaque atque. Iure dicta error. Illum occaecati vitae.
    Architecto adipisci corporis. Animi occaecati quod. Voluptatem reiciendis qui.
    ",
    pro: false,
    proposal_user: proposal_user_one
  )

  10.times do |i|
    FeedbackGroup.create! active: true,
                          priority: i + 1,
                          title: "Review Priority #{i + 1}"
  end

  # - + - feedback - + -

  # - + - roadmap - + -

  solo_now = RoadmapGroup.create!(title: 'solo now',
                                  status: 'now',
                                  inbox: inbox,
                                  account: web_widget.account,
                                  due_by: Date.new(2007, 5, 12))

  solo_next = RoadmapGroup.create!(title: 'solo next',
                                   status: 'next',
                                   inbox: inbox,
                                   account: web_widget.account,
                                   due_by: Date.new(2007, 5, 12))

  solo_later = RoadmapGroup.create!(title: 'solo later',
                                    status: 'later',
                                    inbox: inbox,
                                    account: web_widget.account,
                                    due_by: Date.new(2007, 5, 12))

  intergate_reddit = RoadmapItem.create!(title: 'Intergate Reddit',
                                         body: 'Intergate the social media  network, Reddit',
                                         due_by: Date.new(2007, 5, 12))

  intergate_dropbox = RoadmapItem.create!(title: 'Intergate Dropbox',
                                          body: 'Intergate cloud storage and file storage - Dropbox',
                                          due_by: Date.new(2007, 5, 12))

  intergate_slack = RoadmapItem.create!(title: 'Intergate Slack',
                                        body: 'Intergate platform for team communication - Slack',
                                        feedback: feedback_one,
                                        due_by: Date.new(2007, 5, 12))

  RoadmapGroupItem.create!(roadmap_group: solo_now,
                           roadmap_item: intergate_reddit)

  RoadmapGroupItem.create!(roadmap_group: solo_next,
                           roadmap_item: intergate_dropbox)

  RoadmapGroupItem.create!(roadmap_group: solo_later,
                           roadmap_item: intergate_slack)

  # - + - roadmap - + -

  # - + - changelog - + -

  solo_done = RoadmapGroup.create!(title: 'solo done',
                                   status: 'done',
                                   inbox: inbox,
                                   account: web_widget.account,
                                   due_by: Date.new(2007, 5, 12))

  drag_drop = RoadmapItem.create!(title: 'Drag and Drop',
                                  body: 'Enable drag and drop, copy & paste image/files in the agent input box.',
                                  due_by: Date.new(2007, 5, 12))

  brand_icon = RoadmapItem.create!(title: 'Brand Icon',
                                   body: 'Ability to set brand icon as staff/ agent avatar',
                                   due_by: Date.new(2007, 5, 12))

  dialogflow_integration = RoadmapItem.create!(title: 'Dialogflow Integration',
                                               body: 'Intergate Dialogflow  platform,',
                                               feedback: feedback_two,
                                               due_by: Date.new(2007, 5, 12))

  RoadmapGroupItem.create!(roadmap_group: solo_done,
                           roadmap_item: drag_drop)

  RoadmapGroupItem.create!(roadmap_group: solo_done,
                           roadmap_item: brand_icon)

  RoadmapGroupItem.create!(roadmap_group: solo_done,
                           roadmap_item: dialogflow_integration)

  # - + - changelog - + -
end
