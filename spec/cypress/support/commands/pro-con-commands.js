const conTestMessage = 'rainbow iw';
const proTestMessage = 'hall brawl8';

Cypress.Commands.add('RunProConSpecs', () => {
  cy.createProCon(proTestMessage, 'pro', {pros: 1, cons: 0});
  cy.createProCon(conTestMessage, 'con',{pros: 1, cons: 1});
  cy.cancelNewProCon('cancel-btn');
  cy.cancelNewProCon('cancel-icon');
  cy.cancelNewProCon('cancel-modal-mask');
  cy.deleteProCon();
});

Cypress.Commands.add('createProCon', (message, kind, counter) => {
  cy.get(`[data-test-id="more-toolbar-btn"]`)
    .last()
    .click();
  cy.get('[data-test-id="proposal-add-pro-con"]')
    .click();
  cy.get('[data-test-id="new-pro-con-title"]')
  cy.get('[data-test-id="new-pro-con-textarea-body"]')
    .type(conTestMessage);
  cy.get(`[data-test-id="new-pro-con-radio-${kind}"]`)
    .click();
  cy.get('[data-test-id="new-pro-con-submit-btn"]')
    .click();
  cy.get('[data-test-id="pro-con-show-btn"]')
    .contains(`show pros(${counter.pros}) cons(${counter.cons})`)
    .click();
  cy.get('[data-test-id="pro-con-body"]')
    .last()
    .contains(conTestMessage);
  cy.get('[data-test-id="pro-con-heading"]')
    .last()
    .contains(kind.charAt(0).toUpperCase() + kind.slice(1));
  cy.get('[data-test-id="pro-con-card"]')
    .last()
    .should('have.class', kind)
  cy.get('[data-test-id="pro-con-hide-btn"]')
    .last()
    .click();
  cy.get('[data-test-id="new-pro-con-title"]')
    .should('not.exist')
});

Cypress.Commands.add('cancelNewProCon', (kind) => {
  cy.get(`[data-test-id="more-toolbar-btn"]`)
    .last()
    .click();
  cy.get('[data-test-id="proposal-add-pro-con"]')
    .click();
  cy.get('[data-test-id="new-pro-con-title"]')
  cy.get(`[data-test-id="new-pro-con-${kind}"]`)
    .click('right');
  cy.get('[data-test-id="new-pro-con-title"]')
    .should('not.exist')
  cy.get('[data-test-id="proposal-body"]')
    .last()
    .click();
});


Cypress.Commands.add('deleteProCon', (kind) => {
  cy.get('[data-test-id="pro-con-show-btn"]')
    .contains(`show pros(1) cons(1)`)
    .click();
  cy.get(`[data-test-id="pro-con-actions-btn"]`)
    .last()
    .click();
  cy.get('[data-test-id="pro-con-actions-delete-btn"]')
    .click();
  cy.get('[data-test-id="pro-con-hide-btn"]')
    .click();
  cy.get('[data-test-id="pro-con-show-btn"]')
    .contains(`show pros(1) cons(0)`);
});
