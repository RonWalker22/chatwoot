let testMessageOne = 'landy candy 2';
let testMessageTwo = 'red wing 21';

Cypress.Commands.add('RunCommentsSpecs', (message) => {
  cy.addNewComment(testMessageOne, 0)

  cy.deleteComment(0)
  cy.get('[data-test-id="proposal-card"]')
    .eq(1)
    .find('[data-test-id="comments-show-btn"]')
    .click()
  cy.deleteComment(1)
});

Cypress.Commands.add('addNewComment', (message, index) => {
  cy.get('[data-test-id="proposal-comment-preview-reply-btn"]')
    .eq(index)  
    .click();
  cy.get('[data-test-id="proposal-comment-textarea"]')
    .type(message);
  cy.get('[data-test-id="proposal-comment-cancel-btn"]')
    .click()
  cy.get('[data-test-id="proposal-comment-preview-reply-btn"]')
    .eq(index) 
    .click();
  cy.get('[data-test-id="proposal-comment-textarea"]')
    .should('be.empty')
    .type(message);
  cy.get('[data-test-id="proposal-comment-submit-btn"]')
    .click()
  cy.get('[data-test-id="proposal-comment-body"]')
    .eq(index)
    .contains(message);
});

Cypress.Commands.add('deleteComment', (index) => {
  cy.get('[data-test-id="proposal-card"]')
    .eq(index)
    .find('[data-test-id="more-toolbar-btn-comment"]')
    .click()
  cy.get('[data-test-id="proposal-card"]')
    .eq(index)
    .find('[data-test-id="delete-comment"]')
    .click()
  cy.get('[data-test-id="proposal-card"]')
    .eq(index)
    .find('[data-test-id="more-toolbar-btn-comment"]')
    .should('not.exist');
});