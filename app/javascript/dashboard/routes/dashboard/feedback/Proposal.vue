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
        <div class="columns shrink">
          <button v-if="isPrimarySolution">
            <i
              class="ion-checkmark-round primary-text-color"
              title="Selected Solution"
            ></i>
          </button>
        </div>
        <div class="columns" />
        <div v-if="isSolution" class="columns shrink">
          <button
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
      <div class="row align-middle">
        <div class="columns">
          <h6
            class="text-center"
            :class="{
              'primary-text-color': isPrimarySolution,
              'black-text text-center': isProblem,
            }"
          >
            {{ proposalTitle }}
          </h6>
        </div>
      </div>
      <p>Proposed by: {{ proposal.proposer }}</p>
      <div class="card-section">
        <p>{{ proposal.details }}</p>
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
    ...mapActions('feedback', ['deleteSolution']),
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
  border-left: 5px solid $color-woot !important;
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
</style>
