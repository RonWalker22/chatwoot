// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add("login", (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This is will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })

Cypress.Commands.add('login', () => {
  cy.visit('/');
  cy.get("[data-testid='email_input']")
    .type('john@acme.inc');
  cy.get("[data-testid='password_input']")
    .type('123456');
  cy.get("[data-testid='submit_button']").click();
  cy.get("[data-test-id='no-conversation-selected']")
  cy.get("[data-test-id='main-sidebar-item-feedback_home']")
    .click();
  cy.get("[data-test-id='feedback-tab-review']")
    .click();
  cy.get("[data-test-id='feedback-list-card']")
    .first()
    .click();
  cy.get('[data-test-id="feedback-title"]');
});