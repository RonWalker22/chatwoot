# loading installation configs
ConfigLoader.new.process

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

# - + - feedback - + -

feedback_one = Feedback.create!(
  title: 'Patreon integration - Give IK4 credit for patreon pledges',
  funding_goal: 1000,
  requester_id: contact.id,
  web_widget_id: web_widget.id,
  status: 'active'
)
feedback_two = Feedback.create!(
  title: 'Import feature requests from other platforms',
  funding_goal: 1000,
  requester_id: contact.id,
  web_widget_id: web_widget.id,
  status: 'active'
)
feedback_three = Feedback.create!(
  title: 'Support organizations with multiple products',
  funding_goal: 1000,
  requester_id: contact.id,
  web_widget_id: web_widget.id,
  status: 'active'
)

feedback_contact_one = FeedbackContact.create! contact_id: contact.id,
                                               feedback_id: feedback_one.id,
                                               support_level: 600,
                                               prefund_level: 600,
                                               supporter: true

feedback_contact_two = FeedbackContact.create! contact_id: contact.id,
                                               feedback_id: feedback_two.id,
                                               support_level: 900,
                                               prefund_level: 900,
                                               supporter: true

feedback_contact_three = FeedbackContact.create! contact_id: contact.id,
                                                 feedback_id: feedback_three.id,
                                                 support_level: 200,
                                                 prefund_level: 200,
                                                 supporter: true

problem_one = Problem.create!(
  feedback_contact_id: feedback_contact_one.id,
  details: "Because I have use the IK4 platform and patreon, some of my
   supporters might transition from pledging monthly to one-time contributions.
   I don't want to discourage any of my supporters from canceling or lowering
   their monthly pledges.",
  primary: true
)
solution_one = Solution.create!(
  feedback_contact_id: feedback_contact_one.id,
  details: 'Provide patreon supporters with dollar for dollar credit for each pledge.',
  primary: true
)
ProblemSolution.create! problem_id: problem_one.id, solution_id: solution_one.id

problem_two = Problem.create!(
  feedback_contact_id: feedback_contact_two.id,
  details: 'I am transitioning from another platform and have a lot of data from their that I can’t utilize.',
  primary: true
)
solution_two = Solution.create!(
  feedback_contact_id: feedback_contact_two.id,
  details: 'Add the ability to import feedback from other platforms.',
  primary: true
)
ProblemSolution.create! problem_id: problem_two.id, solution_id: solution_two.id

problem_three = Problem.create!(
  feedback_contact_id: feedback_contact_three.id,
  details: 'Switching between different organization accounts in order to manage multiple products is time consuming.',
  primary: true
)
solution_three = Solution.create!(
  feedback_contact_id: feedback_contact_three.id,
  details: 'Allow each organization to have multiple products and associate
  customers and feature request to individual products instead of the
  organization. This way I don’t have to sign in and out of my account to
  management multiple products that are tied to the same organization.',
  primary: true
)
ProblemSolution.create! problem_id: problem_three.id, solution_id: solution_three.id

# - + - feedback - + -
