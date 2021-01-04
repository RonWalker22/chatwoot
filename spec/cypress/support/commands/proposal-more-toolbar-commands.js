const testMessage = 'wing ride 24';

Cypress.Commands.add('RunProposalMoreToolbarSpecs', () => {
  cy.deleteProposal();
  cy.removePrimary();
  cy.addPrimary();
  cy.deleteProposalCommnet();
});

Cypress.Commands.add('deleteProposal', () => {
  cy.get('[data-test-id="proposal-body"]')
    .should('have.length', 5)
  cy.get(`[data-test-id="more-toolbar-btn"]`)
    .eq(-2)
    .click();
  cy.get(`[data-test-id="delete-proposal"]`)
    .click();
  cy.get('[data-test-id="proposal-body"]')
    .should('have.length', 4);
});

Cypress.Commands.add('removePrimary', () => {
  cy.get('[data-test-id="proposal-card"]')
    .eq(1)
    .should('have.class', 'primary-card')
  cy.get(`[data-test-id="more-toolbar-btn"]`)
    .first()
    .click();
  cy.get(`[data-test-id="proposal-remove-primary"]`)
    .click();
  cy.get('[data-test-id="proposal-card"]')
    .eq(1)
    .should('have.class', 'solution-card')
    .not('.primary-card');
});

Cypress.Commands.add('addPrimary', () => {
  cy.get('[data-test-id="proposal-card"]')
    .eq(1)
    .should('have.class', 'solution-card')
    .not('.primary-card');
  cy.get(`[data-test-id="more-toolbar-btn"]`)
    .first()
    .click();
  cy.get(`[data-test-id="proposal-add-primary"]`)
    .click();
  cy.get('[data-test-id="proposal-card"]')
    .eq(1)
    .should('have.class', 'primary-card')
});

Cypress.Commands.add('deleteProposalCommnet', () => {
  cy.get('[data-test-id="proposal-comment-body"]')
    .should('have.length', 1)
  cy.get(`[data-test-id="more-toolbar-btn"]`)
    .last()
    .click();
  cy.get(`[data-test-id="delete-comment"]`)
    .click();
  cy.get('[data-test-id="proposal-comment-body"]')
    .should('not.exist')
});