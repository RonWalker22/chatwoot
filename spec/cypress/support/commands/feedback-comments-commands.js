let testMessageOne = 'landy candy 2';
let testMessageTwo = 'red wing 21';

Cypress.Commands.add('addNewComment', (message) => {
  cy.get('[data-test-id="proposal-comment-preview-btn"]')
    .eq(-2)  
    .click();
  cy.get('[data-test-id="proposal-comment-textarea"]')
    .type(testMessageOne);
  cy.get('[data-test-id="proposal-comment-cancel-btn"]')
    .click()
  cy.get('[data-test-id="proposal-comment-preview-btn"]')
    .eq(-2)  
    .click();
  cy.get('[data-test-id="proposal-comment-textarea"]')
    .should('be.empty')
    .type(testMessageTwo);
  cy.get('[data-test-id="proposal-comment-submit-btn"]')
    .click()
  cy.get('[data-test-id="proposal-comment-body"]')
    .last()
    .contains(testMessageTwo);
});