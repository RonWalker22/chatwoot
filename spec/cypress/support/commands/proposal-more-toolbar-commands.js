const testMessage = 'wing ride 24';

Cypress.Commands.add('RunProposalMoreToolbarSpecs', () => {
  cy.deleteProposal();
  cy.addPrimary();
  cy.removePrimary();
});

Cypress.Commands.add('deleteProposal', () => {
  cy.get('[data-test-id="proposal-body"]').then(($pbody) => {
    const counter = $pbody.length;
    cy.get(`[data-test-id="more-toolbar-btn-solution"]`)
      .eq(-2)
      .click();
    cy.get(`[data-test-id="delete-proposal"]`)
      .click();
    cy.get(`[data-test-id="proposal-body"]`)
      .should('have.length', counter - 1);
  })
});

Cypress.Commands.add('removePrimary', () => {
  cy.get('[data-test-id="proposal-card"]')
    .eq(1)
    .find(`[data-test-id="proposal-primary-checkmark"]`)
  cy.get(`[data-test-id="more-toolbar-btn-solution"]`)
    .first()
    .click();
  cy.get(`[data-test-id="proposal-remove-primary"]`)
    .click();
  cy.get('[data-test-id="proposal-card"]')
    .eq(1)
    .find(`[data-test-id="proposal-primary-checkmark"]`)
    .should('not.exist');
});

Cypress.Commands.add('addPrimary', () => {
  cy.get('[data-test-id="proposal-card"]')
    .eq(1)
    .find(`[data-test-id="proposal-primary-checkmark"]`)
    .should('not.exist');
  cy.get(`[data-test-id="more-toolbar-btn-solution"]`)
    .first()
    .click();
  cy.get(`[data-test-id="proposal-add-primary"]`)
    .click();
  cy.get('[data-test-id="proposal-card"]')
  .eq(1)
  .find(`[data-test-id="proposal-primary-checkmark"]`)
});