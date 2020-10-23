<template>
  <div class="card" :class="{ 'problem-card': !proposal.solution }">
    <div class="row align-middle">
      <div class="columns shrink">
        <i
          v-if="proposal.primary"
          class="ion-star"
          :title="'Primary ' + proposalType"
          :class="{ 'primary-text-color': isPrimarySolution }"
        >
        </i>
      </div>
      <div class="columns">
        <h6
          class="text-center"
          :class="{ 'primary-text-color': isPrimarySolution }"
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
</template>

<script>
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
      let messageStart = this.isPrimaryProposal ? 'Primary' : 'Alternative';
      let messageMiddle = this.proposalType;
      let messageEnd = this.isSolution ? '- # ' + (this.index + 1) : '';

      return `${messageStart} ${messageMiddle} ${messageEnd}`;
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~dashboard/assets/scss/variables';

.ion-star {
  font-size: 30px;
}

.card {
  padding: 2em;
  border-radius: 25px;
}

.primary-card {
  border: 3px solid $color-woot;
}

.primary-text-color {
  color: $color-woot;
}

.problem-card {
  border-radius: 0px;
}
</style>
