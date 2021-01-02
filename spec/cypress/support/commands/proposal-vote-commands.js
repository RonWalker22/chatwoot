Cypress.Commands.add('RunProposalVoteSpecs', () => {
  (function upvoteDownvoteTwice() {
    cy.clickVote('up');
    cy.voteDirectionCheck('up');
    cy.voteScoreCheck(1);
    cy.clickVote('down');
    cy.voteDirectionCheck('down');
    cy.voteScoreCheck(-1);

    // reset vote
    cy.clickVote('down');
    cy.voteDirectionCheck('');
    cy.voteScoreCheck(0);
  })();

  (function downvoteUpvoteTwice() {
    cy.clickVote('down');
    cy.voteDirectionCheck('down');
    cy.voteScoreCheck(-1);
    cy.clickVote('up');
    cy.voteDirectionCheck('up');
    cy.voteScoreCheck(1);

    // reset vote
    cy.clickVote('up');
    cy.voteDirectionCheck('');
    cy.voteScoreCheck(0);
  })();
});

Cypress.Commands.add('clickVote', (direction) => {
  cy.get(`[data-test-id="proposal-${direction}vote"]`)
    .eq(-2)
    .click();  
});

Cypress.Commands.add('voteDirectionCheck', (direction) => {
  if (direction === 'up' || direction ===  'down') {
    cy.get(`[data-test-id="proposal-${direction}vote-arrow"]`)
    .eq(-2)
    .should('have.class', `${direction}vote-proposal`);
  } else {
    cy.get(`[data-test-id="proposal-upvote-arrow"]`)
      .eq(-2)
      .should('not.have.class', 'upvote-proposal');
    cy.get(`[data-test-id="proposal-downvote-arrow"]`)
      .eq(-2)
      .should('not.have.class', 'downvote-proposal');
  }
});

Cypress.Commands.add('voteScoreCheck', (score) => {
  cy.get(`[data-test-id="proposal-vote-score"]`)
    .eq(-2)
    .contains(score);
});