Cypress.Commands.add('RunFeedbackCardSpecs', (feedbackIndex) => {
  
  cy.get('[data-test-id="feedback-tab-active"]')
  .should('have.class', 'is-active')
  cy.get('[data-test-id="feedback-tab-review"]')
    .not('.is-active');
  cy.get('[data-test-id="feedback-list-card"]')
    .first()
    .not('card-active')
  cy.get('[data-test-id="feedback-list-card"]')
    .first()
    .should('have.class', 'card-active');
  cy.get('[data-test-id="feedback-list-card"]')
    .last()
    .click();
  cy.get('[data-test-id="feedback-list-card"]')
    .last()
    .should('have.class', 'card-active');
  cy.get('[data-test-id="feedback-list-card"]')
    .first()
    .not('card-active');
});