Cypress.Commands.add('clickFeedbackEvaluation', (evaluation) => {
  cy.wait(100);
  cy.get(`[data-test-id="${evaluation}-feedback-btn"]`)
    .click()
});

Cypress.Commands.add('feedbackEvaluationIs', (evaluation) => {
  cy.wait(500);
  if (evaluation === 'support' || evaluation === 'reject') {
    cy.get(`[data-test-id="${evaluation}-feedback-btn"]`)
      .not('.pick-unselected')
      .should('have.class', `${evaluation}-selected`);
  } else {
    cy.get(`[data-test-id="reject-feedback-btn"]`)
      .should('have.class', 'pick-unselected')
      .not('.reject-selected');
    cy.get(`[data-test-id="support-feedback-btn"]`)
      .should('have.class', 'pick-unselected')
      .not('.support-selected');
  }
});

Cypress.Commands.add('feedbackEvaluationReset', (evaluation) => {
  cy.clickFeedbackEvaluation('support');
  cy.clickFeedbackEvaluation('reject');
  cy.clickFeedbackEvaluation('reject');
});



Cypress.Commands.add('clickNewSolution', () => {
  cy.get('[data-test-id="new-solution-btn"]')
    .click();
  cy.get('[data-test-id="new-solution-title"]')
    .contains('New Solution');
});
Cypress.Commands.add('typeSolutionText', (content) => {
  cy.get('[data-test-id="new-solution-textarea"]')
    .type(content);
});
Cypress.Commands.add('submitNewSolution', () => {
  cy.get('[data-test-id="new-solution-submit-btn"]')
    .click();
});
Cypress.Commands.add('confirmSubmission', (content) => {
  cy.get('[data-test-id="proposal-body"]')
    .should('have.length', 5)
    .last()
    .contains(content);
});
Cypress.Commands.add('cancelWithBtn', () => {
  cy.get('[data-test-id="new-solution-cancel-btn"]')
    .click();
});
Cypress.Commands.add('cancelWithIcon', () => {
  cy.get('[data-test-id="new-solution-cancel-icon"]')
    .click();
});
Cypress.Commands.add('confirmCancel', () => {
  cy.get('[data-test-id="new-solution-title"]')
    .should('not.exist');
});

Cypress.Commands.add('clickVote', (direction) => {
  cy.get(`[data-test-id="proposal-${direction}vote"]`)
    .eq(-2)
    .click();  
});

Cypress.Commands.add('voteScoreCheck', (score) => {
  cy.get(`[data-test-id="proposal-vote-score"]`)
    .eq(-2)
    .contains(score);
});

Cypress.Commands.add('voteDirectionCheck', (direction) => {
  if (direction === 'up' || direction ===  'down') {
    cy.get(`[data-test-id="proposal-${direction}vote-arrow"]`)
    .eq(-2)
    .should('have.class', `${direction}vote-proposal`);
  } else {
    cy.get(`[data-test-id="proposal-upvote-arrow"]`)
      .eq(-2)
      .should('not.have.class', 'upvote-proposal');
    cy.get(`[data-test-id="proposal-downvote-arrow"]`)
      .eq(-2)
      .should('not.have.class', 'downvote-proposal');
  }
});



Cypress.Commands.add('addNewComment', (message, commentLength) => {
  cy.get('[data-test-id="proposal-comment-textarea"]')
    .eq(-2)
    .type(message);
  cy.get('[data-test-id="proposal-comment-btn"]')
    .eq(-2)
    .click();
  cy.get('[data-test-id="proposal-comment-body"]')
    .should('have.length', commentLength)
    .last()
    .contains(message);
});

Cypress.Commands.add('RunNewProposalSpecs', (content) => {
  (function createNewSolution() {
    cy.clickNewSolution();
    cy.typeSolutionText(content);
    cy.submitNewSolution();
    cy.confirmSubmission(content);
  })();

  (function newSolutionIconCancel() {
    cy.clickNewSolution();
    cy.typeSolutionText(content);
    cy.cancelWithIcon();
    cy.confirmCancel();
  })();

  (function newSolutionIconButton() {
    cy.clickNewSolution();
    cy.typeSolutionText(content);
    cy.cancelWithBtn();
    cy.confirmCancel();
  })();
});

Cypress.Commands.add('RunFeedbackEvaluationSpecs', (content) => {
  
  cy.feedbackEvaluationReset();

  (function RejectSupportFeedback() {
    cy.clickFeedbackEvaluation('support');
    cy.feedbackEvaluationIs('support');
    cy.clickFeedbackEvaluation('reject');
    cy.feedbackEvaluationIs('reject');
  })();

  cy.feedbackEvaluationReset();

  (function ResetEvaluationSupport() {
    cy.clickFeedbackEvaluation('support');
    cy.feedbackEvaluationIs('support');
    cy.clickFeedbackEvaluation('support');
    cy.feedbackEvaluationIs('');
  })();
  
  cy.feedbackEvaluationReset();

  (function ResetEvaluationReject() {
    cy.clickFeedbackEvaluation('reject');
    cy.feedbackEvaluationIs('reject');
    cy.clickFeedbackEvaluation('reject');
    cy.feedbackEvaluationIs('');
  })();
});

Cypress.Commands.add('RunProposalVoteSpecs', (content) => {
  (function createNewSolution() {
    cy.clickNewSolution();
    cy.typeSolutionText(content);
    cy.submitNewSolution();
    cy.confirmSubmission(content);
  })();

  (function newSolutionIconCancel() {
    cy.clickNewSolution();
    cy.typeSolutionText(content);
    cy.cancelWithIcon();
    cy.confirmCancel();
  })();

  (function newSolutionIconButton() {
    cy.clickNewSolution();
    cy.typeSolutionText(content);
    cy.cancelWithBtn();
    cy.confirmCancel();
  })();
});

Cypress.Commands.add('RunProposalCommentSpecs', (content) => {
  (function createNewSolution() {
    cy.clickNewSolution();
    cy.typeSolutionText(content);
    cy.submitNewSolution();
    cy.confirmSubmission(content);
  })();

  (function newSolutionIconCancel() {
    cy.clickNewSolution();
    cy.typeSolutionText(content);
    cy.cancelWithIcon();
    cy.confirmCancel();
  })();

  (function newSolutionIconButton() {
    cy.clickNewSolution();
    cy.typeSolutionText(content);
    cy.cancelWithBtn();
    cy.confirmCancel();
  })();
});

Cypress.Commands.add('RunProposalVoteSpecs', (content) => {
  (function upvoteDownvoteTwice() {
    cy.clickVote('up');
    cy.voteDirectionCheck('up');
    cy.voteScoreCheck(1);
    cy.clickVote('down');
    cy.voteDirectionCheck('down');
    cy.voteScoreCheck(-1);

    // reset vote
    cy.clickVote('down');
    cy.voteDirectionCheck('');
    cy.voteScoreCheck(0);
  })();

  (function downvoteUpvoteTwice() {
    cy.clickVote('down');
    cy.voteDirectionCheck('down');
    cy.voteScoreCheck(-1);
    cy.clickVote('up');
    cy.voteDirectionCheck('up');
    cy.voteScoreCheck(1);

    // reset vote
    cy.clickVote('up');
    cy.voteDirectionCheck('');
    cy.voteScoreCheck(0);
  })();
});


Cypress.Commands.add('startNewFeedback', () => {
  cy.clickEditFeedbackBtn();
  cy.inputNewFeedbackTitle();
  cy.selectNewFeedbackStatus();
  cy.selectNewFeedbackType()
});

Cypress.Commands.add('startNewFeedback', () => {
  cy.clickCancelNewFeedback('mask');
  cy.confirmNewFeedbackCanceled();
});

Cypress.Commands.add('RunProposalVoteSpecs', (content) => {
  (function upvoteDownvoteTwice() {
    cy.clickVote('up');
    cy.voteDirectionCheck('up');
    cy.voteScoreCheck(1);
    cy.clickVote('down');
    cy.voteDirectionCheck('down');
    cy.voteScoreCheck(-1);

    // reset vote
    cy.clickVote('down');
    cy.voteDirectionCheck('');
    cy.voteScoreCheck(0);
  })();

  (function downvoteUpvoteTwice() {
    cy.clickVote('down');
    cy.voteDirectionCheck('down');
    cy.voteScoreCheck(-1);
    cy.clickVote('up');
    cy.voteDirectionCheck('up');
    cy.voteScoreCheck(1);

    // reset vote
    cy.clickVote('up');
    cy.voteDirectionCheck('');
    cy.voteScoreCheck(0);
  })();
});