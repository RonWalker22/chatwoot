Cypress.Commands.add('RunFeedbackEvaluationSpecs', () => {
  
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

Cypress.Commands.add('feedbackEvaluationReset', () => {
  cy.clickFeedbackEvaluation('support');
  cy.clickFeedbackEvaluation('reject');
  cy.clickFeedbackEvaluation('reject');
});


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