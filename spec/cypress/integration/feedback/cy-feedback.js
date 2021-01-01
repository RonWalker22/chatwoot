import '../../support/commands/feedback-commands';
import '../../support/commands/edit-feedback-commands';
import '../../support/commands/new-feedback-commands';
import '../../support/commands/feedback-card-commands';
const feedbackInteractions = function(testMessage, commentLength) {
  it('Feedback Evaluation Specs', function() {
    cy.RunFeedbackEvaluationSpecs(testMessage);
  })

  it('Proposal Vote Specs', function() {
    cy.RunProposalVoteSpecs(testMessage);
  })

  it('add new comment', function() {
    cy.addNewComment(testMessage, commentLength);
  });
};


describe('Feedback interactions with & without new Proposal', function() {
  before(() => {
    cy.app('clean');
    cy.appScenario('default');
    cy.login();
  });

  let testMessageOne = 'landy candy 2';
  let testMessageTwo = 'red wing 21';

  // 'without new proposal'
  feedbackInteractions(testMessageOne, 1);

  it('create new proposal', function() {
    cy.RunNewProposalSpecs('NEW Proposal');
  })

  // 'with new proposal'
  feedbackInteractions(testMessageTwo, 2);

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
})