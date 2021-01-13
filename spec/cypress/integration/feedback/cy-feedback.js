import '../../support/commands/feedback-evaluation-commands';
import '../../support/commands/edit-feedback-commands';
import '../../support/commands/new-feedback-commands';
import '../../support/commands/feedback-card-commands';
import '../../support/commands/feedback-comments-commands';
import '../../support/commands/proposal-vote-commands';
import '../../support/commands/new-proposal-commands';
import '../../support/commands/proposal-more-toolbar-commands';
import '../../support/commands/pro-con-commands';


const feedbackInteractions = function() {
  it('Feedback Evaluation Specs', function() {
    cy.RunFeedbackEvaluationSpecs();
  })

  it('Proposal Vote Specs', function() {
    cy.RunProposalVoteSpecs();
  })

  it('add new comment', function() {
    cy.addNewComment();
  });
};


describe('Feedback interactions with & without new Proposal', function() {
  before(() => {
    cy.app('clean');
    cy.appScenario('default');
    cy.login();
  });

  // 'without new proposal'
  feedbackInteractions();

  it('create new proposal', function() {
    cy.RunNewProposalSpecs('NEW Proposal');
  })

  // 'with new proposal'
  feedbackInteractions();

  it('proposal more toolbar specs', function() {
    cy.RunProposalMoreToolbarSpecs();
  })

  it('edit feedback - finish', function() {
    cy.RunEditFeedbackSpecs('finish');
  })

  it('edit feedback - start and cancel with button', function() {
    cy.login();
    cy.visit('/app/accounts/1/feedback/2');
    cy.RunEditFeedbackSpecs('btn');
  })

  it('edit feedback - start and cancel with icon', function() {
    cy.RunEditFeedbackSpecs('icon');
  })

  it('edit feedback - start and cancel with modal mask', function() {
    cy.RunEditFeedbackSpecs('mask');
  })

  it('new feedback - finish', function() {
    cy.login();
    cy.visit('/app/accounts/1/feedback');
    cy.RunNewFeedbackSpecs('finish');
  })

  it('new feedback - start and close with icon', function() {
    cy.login();
    cy.visit('/app/accounts/1/feedback');
    cy.RunNewFeedbackSpecs('close','icon');
  })

  it('new feedback - start and cancel with button', function() {
    cy.RunNewFeedbackSpecs('cancel','btn');
  })

  it('new feedback - start and close with modal mask', function() {
    cy.RunNewFeedbackSpecs('close','mask');
  })

  it('RunFeedbackCardSpecs', function() {
    cy.login();
    cy.visit('/app/accounts/1/feedback/2');
    cy.RunFeedbackCardSpecs();
  })

  it('RunProConSpecs', function() {
    cy.login();
    cy.visit('/app/accounts/1/feedback/4');
    cy.RunProConSpecs();
  })
})