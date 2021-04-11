const editOptions = {
  finalJudgment: ['reject', 'accept'],
  moveTo: ['upcoming', 'review', 'preview'],
  changeType: ['feature', 'bug'],
  newTitle: "GoTosGoTo",
  oldTitle: 'Hide vote results during the review',
}

Cypress.Commands.add('finishBulkEditFeedback', (editType) => {
  cy.get(`[data-test-id="feedback-status-label"]`)
    .contains(editOptions.moveTo[1])
  cy.get(`[data-test-id="edit-feedback-btn"]`)
    .click();
  cy.get(`[data-test-id="bulk-edit-status-change-${editType}"]`)
    .click()
  cy.get(`[data-test-id="feedback-status-label"]`)
    .contains(editType)
});

Cypress.Commands.add('cancelBulkEditFeedback', () => {
  cy.get(`[data-test-id="feedback-title"]`)
  cy.get(`[data-test-id="edit-feedback-btn"]`)
    .click();
  cy.get(`[data-test-id="feedback-title"]`)
    .should('not.exist')
  cy.get(`[data-test-id="bulk-edit-cancel-btn"]`)
    .click();
  cy.get(`[data-test-id="feedback-title"]`)
});

Cypress.Commands.add('updateTitle', () => {
  cy.get(`[data-test-id="feedback-title"]`)
    .contains(editOptions.oldTitle)
  cy.get(`[data-test-id="edit-feedback-btn"]`)
    .click();
  cy.get(`[data-test-id="bulk-edit-title-input"]`)
    .should('have.value', editOptions.oldTitle)
    .clear()
    .type(editOptions.newTitle);
  cy.get(`[data-test-id="bulk-edit-update-btn"]`)
    .click()
  cy.get(`[data-test-id="feedback-title"]`)
    .contains(editOptions.newTitle)
});



Cypress.Commands.add('RunEditFeedbackSpecs', () => {
  cy.cancelBulkEditFeedback();
  cy.updateTitle();
  cy.finishBulkEditFeedback('preview');
});