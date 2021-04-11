import '../../support/commands/feedback-evaluation-commands';
import '../../support/commands/edit-feedback-commands';
import '../../support/commands/new-feedback-commands';
import '../../support/commands/feedback-card-commands';
import '../../support/commands/feedback-comments-commands';
import '../../support/commands/proposal-vote-commands';
import '../../support/commands/new-proposal-commands';
import '../../support/commands/proposal-more-toolbar-commands';
import '../../support/commands/pro-con-commands';

describe('Feedback interactions with & without new Proposal', function() {
  before(() => {
    cy.login();
  });

  it('create new proposal', function() {
    cy.RunNewProposalSpecs('NEW Proposal');
  })

  it('Feedback Evaluation Specs', function() {
    cy.RunFeedbackEvaluationSpecs();
  })

  it('Proposal Vote Specs', function() {
    cy.RunProposalVoteSpecs();
  })

  it('add new comment', function() {
    cy.RunCommentsSpecs();
  });

  it('proposal more toolbar specs', function() {
    cy.RunProposalMoreToolbarSpecs();
  })

  it('bulk edit feedback', function() {
    cy.RunEditFeedbackSpecs();
  })

  it.only('new feedback', function() {
    // cy.login();
    // cy.visit('/app/accounts/1/feedback');
    cy.RunNewFeedbackSpecs();
  })

  it('RunFeedbackCardSpecs', function() {
    cy.login();
    cy.visit('/app/accounts/1/feedbacks/2');
    cy.RunFeedbackCardSpecs();
  })

  it('RunProConSpecs', function() {
    cy.login();
    cy.visit('/app/accounts/1/feedbacks/4');
    cy.RunProConSpecs();
  })
})