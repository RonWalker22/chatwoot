const feedbackStatic = {
  title: 'Import feature requests from other platforms',
  status: {name: 'active' , value: 'active'},
  kind: {name: 'Feature Request' , value: 'request'}
};

const feedbackEdits = {
  title: 'new title - war82',
  status: {name: 'Review' , value: 'review'},
  kind: {name: 'General' , value: 'general'}
};

const feedbackEditsSecond = {
  title: 'new title - happy22',
  status: {name: 'Resolved' , value: 'resolved'},
  kind: {name: 'Bug Report' , value: 'bug'}
};

Cypress.Commands.add('startEditFeedback', () => {
  cy.get(`[data-test-id="edit-feedback-btn"]`)
    .click();
  cy.get(`[data-test-id="edit-feedback-new-title-input"]`)
    .type(feedbackEdits.title);
  cy.get(`[data-test-id="edit-feedback-change-status-select"]`)
    .select(feedbackEdits.status.name)
    .should('have.value', feedbackEdits.status.value);
  cy.get(`[data-test-id="edit-feedback-change-type-select"]`)
    .select(feedbackEdits.kind.name)
    .should('have.value', feedbackEdits.kind.value);
});

Cypress.Commands.add('finishEditFeedback', () => {
  cy.get(`[data-test-id="edit-feedback-submit-btn"]`)
    .click();
  cy.get(`[data-test-id="feedback-title"]`)
    .contains(feedbackEdits.title);
  cy.get(`[data-test-id="feedback-status"]`)
    .contains(feedbackEdits.status.value);
  cy.get(`[data-test-id="feedback-type"]`)
    .contains(feedbackEdits.kind.value);
  cy.get('[data-test-id="edit-feedback-new-title-input"]')
    .should('not.exist');
});

Cypress.Commands.add('cancelEditFeedback', (cancelType) => {
  cy.get(`[data-test-id="edit-feedback-cancel-${cancelType}"]`)
    .click('left');
  cy.get(`[data-test-id="feedback-title"]`)
    .contains(feedbackStatic.title);
  cy.get(`[data-test-id="feedback-status"]`)
    .contains(feedbackStatic.status.value);
  cy.get(`[data-test-id="feedback-type"]`)
    .contains(feedbackStatic.kind.value);
  cy.get('[data-test-id="edit-feedback-new-title-input"]')
    .should('not.exist');
});



Cypress.Commands.add('RunEditFeedbackSpecs', (cancelType) => {
  if (cancelType === 'finish') {
    cy.startEditFeedback();
    cy.finishEditFeedback();
  } else {
    cy.startEditFeedback();
    cy.cancelEditFeedback(cancelType);
  }
});