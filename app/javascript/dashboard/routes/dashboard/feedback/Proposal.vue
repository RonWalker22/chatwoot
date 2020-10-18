<template>
  <div
    v-show="proposalIsSelected"
    class="card"
    :class="{ 'primary-card': isPrimarySolution, 'problem-card': isProblem }"
  >
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
import { mapGetters } from 'vuex';

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
    proposalType: {
      type: String,
      require: true,
      default: '',
    },
  },
  computed: {
    ...mapGetters({
      selectedSolutions: 'feedback/getAllSelectedSolutions',
      selectedProblems: 'feedback/getAllSelectedProblems',
    }),
    isProblem() {
      return this.proposalType === 'Problem';
    },
    proposalIsSelected() {
      if (this.isSolution) {
        return (
          this.selectedSolutions.length === 0 ||
          this.selectedSolutions.includes(this.proposal.id)
        );
      }
      return (
        this.selectedProblems.length === 0 ||
        this.selectedProblems.includes(this.proposal.id)
      );
    },
    isPrimarySolution() {
      return this.isSolution && this.isPrimaryProposal;
    },
    isPrimaryProposal() {
      return this.proposal.primary;
    },
    isSolution() {
      return this.proposalType === 'Solution';
    },
    proposalTitle() {
      let messageStart = this.isPrimaryProposal ? 'Primary' : 'Alternative';
      let messageMiddle = this.proposalType;
      let messageEnd = this.isSolution ? '- # ' + (this.index + 1) : '';

      return `${messageStart} ${messageMiddle} ${messageEnd}`;
    },
  },
  methods: {
    scrollToTop() {
      window.scrollTo({ top: 0, left: 0 });
    },
    proposalFocus() {
      if (this.isSolution) {
        this.updateSelectedProposals({
          problems: this.proposal.problems,
          solutions: [this.proposal.id],
        });
      } else {
        this.updateSelectedProposals({
          problems: [this.proposal.id],
          solutions: this.proposal.solutions,
        });
      }
    },
    updateSelectedProposals(ids) {
      this.$store.dispatch('feedback/selectProposal', {
        problems: ids.problems,
        solutions: ids.solutions,
      });
    },
    linkToMessage() {
      if (this.isSolution) {
        return 'this solution sloves these problems: ';
      }
      return 'this problem is solved by these solutions: ';
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~dashboard/assets/scss/variables';

.ion-pin,
.ion-pinpoint {
  font-size: 20px;
}
.ion-pinpoint {
  cursor: pointer;
}
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
