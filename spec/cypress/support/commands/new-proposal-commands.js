Cypress.Commands.add('RunNewProposalSpecs', (content) => {
  cy.createNewSolution(content);
  cy.newSolutionIconCancel(content);
  cy.newSolutionButtonCancel(content);
});

Cypress.Commands.add('createNewSolution', (content) => {
  cy.clickNewSolution();
  cy.typeSolutionText(content);
  cy.submitNewSolution();
  cy.confirmSubmission(content);
});

Cypress.Commands.add('newSolutionIconCancel', (content) => {
  cy.clickNewSolution();
  cy.typeSolutionText(content);
  cy.cancelWithIcon();
  cy.confirmCancel();
});

Cypress.Commands.add('newSolutionButtonCancel', (content) => {
  cy.clickNewSolution();
  cy.typeSolutionText(content);
  cy.cancelWithBtn();
  cy.confirmCancel();
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
