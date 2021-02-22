<template>
  <div class="card proposal-card" data-test-id="proposal-card" test>
    <div class="proposal-main">
      <div class="row align-top">
        <div class="columns">
          <h2 class="proposal-title">
            {{ proposalType }}
            <span v-if="isSolution" class="solution-id"> #{{ index }}</span>
          </h2>
          <div v-if="isPrimarySolution" class="primary-checkmark">
            <i
              class="ion-checkmark-round"
              title="Selected Solution"
              aria-hidden="true"
            ></i>
            <span class="show-for-sr">Selected Solution</span>
          </div>
          <div class="row align-top">
            <div v-if="isSolution && reviewStatus" class="row">
              <div class="row align-middle align-center">
                <div class="column shrink">
                  <div v-if="reviewStatus">
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
                        {{ proposalScore }}
                      </span>
                    </div>
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
              </div>
            </div>
            <div class="column">
              <div class="card-section">
                <p data-test-id="proposal-body">
                  {{ proposal.details }}
                </p>
              </div>
            </div>
          </div>
        </div>
        <div class="columns shrink">
          <more-actions
            v-if="isSolution"
            :id="proposal.id"
            :proposal="proposal"
            :is-solution="true"
          />
        </div>
      </div>
    </div>
    <pro-cons
      v-if="proposal.pro_cons.length > 0"
      :pro-cons="proposal.pro_cons"
    />
    <div class="row align-right">
      <div class="column shrink">
        <p class="proposal-details">
          proposed
          <span data-test-id="proposal-date">
            {{ proposal.date }}
          </span>
          <span v-if="voted" data-test-id="proposal-author">
            by {{ proposal.user }}
          </span>
        </p>
      </div>
      <div class="column shrink">
        <p class="proposal-details">
          <span v-if="isSolution && voted">({{ proposalScoreDetails }})</span>
        </p>
      </div>
    </div>
    <slot class="comments"></slot>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import MoreActions from './MoreActions';
import ProCons from './ProCons';

export default {
  components: {
    MoreActions,
    ProCons,
  },
  props: {
    index: {
      type: [Number, String],
      required: true,
    },
    proposal: {
      type: Object,
      required: true,
    },
    feedbackStatus: {
      type: String,
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
    voted() {
      return this.proposal.voted;
    },
    proposalScore() {
      return this.voted
        ? this.proposal.score.up - this.proposal.score.down
        : 'vote';
    },
    reviewStatus() {
      return this.feedbackStatus === 'review';
    },
    proposalScoreDetails() {
      const total = this.proposal.score.up + this.proposal.score.down;
      const percentage = (this.proposal.score.up / total) * 100;
      const voteName = total === 1 ? 'vote' : 'votes';
      if (total === 0) {
        return '0 total votes';
      }
      return `${percentage}% support with ${total} total ${voteName}`;
    },
  },
  methods: {
    ...mapActions('feedback', ['setProposalEvaluation']),
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
            id: this.proposal.proposal_user_id,
            voted: true,
          },
          proposal_id: this.proposal.id,
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
  font-size: 25px;
  margin-left: 1rem;
  color: #079307;
}

.card {
  padding: 0;
}

.new-solution-button {
  background-color: black;
}

.proposal-card {
  background: transparent;
  padding: 3em 3em 3em 0;
  border: none;
  border-bottom: solid 2px gainsboro;
}

.proposal-main {
  background: transparent;
  h2 {
    color: #000;
  }
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
  display: block;
  padding-top: 0;
  padding-bottom: 0;
}

.ion-arrow-up-b,
.ion-arrow-down-b {
  font-size: 2em;
}

.proposal-vote-count {
  text-align: center;
  color: #6e767d;
  font-size: 1.8em;
}

.downvote-proposal {
  color: $color-woot;
}

.upvote-proposal {
  color: $color-woot;
}

h2 {
  font-size: $font-size-medium;
}

.solution-id {
  color: #6e767d;
}

.card-section {
  padding: 1rem 1rem 1rem 0rem;
  margin-left: 1rem;
}

.proposal-details {
  font-size: 1.3rem;
}

.primary-checkmark {
  display: inline-block;
}

.proposal-title {
  display: inline-block;
  padding-top: 1rem;
}

.vote-container {
  margin-right: 1rem;
}
</style>
