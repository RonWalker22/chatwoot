<template>
  <div
    class="card proposal-card"
    :class="{
      'primary-card': isPrimarySolution,
      'problem-card': isProblem,
      'solution-card': isSolution,
    }"
  >
    <div class="proposal-main">
      <div class="row align-middle">
        <div v-if="isSolution" class="columns shrink">
          <button v-if="isPrimarySolution">
            <i
              class="ion-checkmark-round primary-text-color"
              title="Selected Solution"
              aria-hidden="true"
            ></i>
            <span class="show-for-sr">Selected Solution</span>
          </button>
        </div>
        <div class="columns">
          <h6
            class="text-center"
            :class="{ 'black-text text-center': isProblem }"
          >
            {{ proposalTitle }}
          </h6>
        </div>
        <div class="columns shrink">
          <button
            v-if="isSolution"
            class="close-btn"
            aria-label="Delete solution"
            title="Delete solution"
            type="button"
            data-close
            @click="deleteSolution(proposal.id)"
          >
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
      </div>
      <div class="row align-top">
        <div v-if="isSolution" class="columns shrink">
          <button
            class="button proposal-vote"
            type="button"
            title="Support proposal"
            data-test-id="proposal-upvote"
            @click="supportProposal"
          >
            <i
              class="ion-arrow-up-b"
              :class="{ 'upvote-proposal': proposalIsSupported }"
              aria-hidden="true"
              data-test-id="proposal-upvote-arrow"
            >
            </i>
            <span class="show-for-sr">Support proposal</span>
          </button>
          <div class="proposal-vote-count">
            <span class="show-for-sr">Proposal score</span>
            <span data-test-id="proposal-vote-score">
              {{ proposal.score }}
            </span>
          </div>
          <div class="row align-middle">
            <button
              class="button proposal-vote"
              type="button"
              title="Reject proposal"
              data-test-id="proposal-downvote"
              @click="rejectProposal"
            >
              <i
                class="ion-arrow-down-b"
                :class="{ 'downvote-proposal': proposalIsRejected }"
                data-test-id="proposal-downvote-arrow"
                aria-hidden="true"
              >
              </i>
              <span class="show-for-sr">Reject proposal</span>
            </button>
          </div>
        </div>
        <div class="columns">
          <div class="card-section">
            <p data-test-id="proposal-author">
              {{ proposal.proposer }}
            </p>
            <p data-test-id="proposal-body">
              {{ proposal.details }}
            </p>
          </div>
        </div>
      </div>
    </div>
    <slot class="comments"></slot>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  props: {
    index: {
      type: [Number, String],
      required: true,
    },
    proposal: {
      type: Object,
      required: true,
    },
  },
  computed: {
    isProblem() {
      return !this.proposal.solution;
    },
    proposalType() {
      return this.proposal.solution ? 'Solution' : 'Problem';
    },
    isPrimarySolution() {
      return this.isSolution && this.isPrimaryProposal;
    },
    isPrimaryProposal() {
      return this.proposal.primary;
    },
    isSolution() {
      return this.proposal.solution;
    },
    proposalIsSupported() {
      return this.proposal.evaluation === 'support';
    },
    proposalIsRejected() {
      return this.proposal.evaluation === 'reject';
    },
    proposalTitle() {
      if (this.isProblem) {
        return this.proposalType;
      }

      let messageStart = this.proposalType;
      let messageEnd = '# ' + this.index;

      return `${messageStart} ${messageEnd}`;
    },
  },
  methods: {
    ...mapActions('feedback', ['deleteSolution', 'setProposalEvaluation']),
    supportProposal() {
      if (this.proposal.evaluation === 'support') {
        this.resetProposalEvaluation();
      } else {
        this.sendProposalEvaluation('support');
      }
    },
    rejectProposal() {
      if (this.proposal.evaluation === 'reject') {
        this.resetProposalEvaluation();
      } else {
        this.sendProposalEvaluation('reject');
      }
    },
    resetProposalEvaluation() {
      this.sendProposalEvaluation('undecided');
    },
    sendProposalEvaluation(kind) {
      this.setProposalEvaluation({
        payload: {
          proposal_user: {
            evaluation: kind,
            proposal_id: this.proposal.id,
            id: this.proposal.proposal_user_id,
          },
        },
        proposalUser: this.checkProposalUser(),
        id: this.proposal.proposal_user_id,
      });
    },
    checkProposalUser() {
      return this.proposal.proposal_user_id !== 0;
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~dashboard/assets/scss/variables';

.ion-checkmark-round {
  font-size: 30px;
  margin-bottom: 1rem;
  display: inline-block;
}

.card {
  padding: 0;
}

.primary-text-color {
  color: $color-woot;
}

.new-solution-button {
  background-color: black;
}

.black-text {
  color: black;
}

.problem-card {
  border: none;
  margin-top: none;
}

.solution-card {
  margin-top: 5em;
  border: none;
  border-left: 2px solid black;
}

.primary-card {
  border: none;
  border: 3px solid $color-woot !important;
}

.comments {
  background: red;
  padding: 3em;
}

.proposal-main {
  background: white;
  border-bottom: 1px solid gainsboro;
  padding: 3em;
}

.proposal-card {
  background: white;
  border: 1px solid gainsboro;
}

.close-btn {
  font-size: 2em;
  :hover {
    cursor: pointer;
  }
}

.proposal-vote {
  border: none;
  color: gray;
  background-color: transparent;
}

.ion-arrow-up-b,
.ion-arrow-down-b {
  font-size: 2em;
}

.proposal-vote-count {
  text-align: center;
  color: gray;
  font-size: 2em;
}

.downvote-proposal {
  color: firebrick;
}

.upvote-proposal {
  color: $color-woot;
}
</style>
