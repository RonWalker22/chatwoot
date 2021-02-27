<template>
  <div>
    <div class="row">
      <div class="columns">
        <Proposal
          v-for="proposal in proposals.problems"
          :key="proposal.id"
          :index="proposal.id"
          :proposal="proposal"
          :feedback-status="feedback.status"
        >
          <Comments
            :proposal-id="proposal.id"
            :feedback-id="proposal.feedback_id"
          />
        </Proposal>
        <Proposal
          v-for="proposal in proposals.primaries"
          :key="proposal.id"
          :index="proposal.id"
          :proposal="proposal"
          :feedback-status="feedback.status"
        >
          <Comments
            :proposal-id="proposal.id"
            :feedback-id="proposal.feedback_id"
          />
        </Proposal>
        <Proposal
          v-for="proposal in proposals.alternatives"
          :key="proposal.id"
          :index="proposal.id"
          :proposal="proposal"
          :feedback-status="feedback.status"
        >
          <Comments
            :proposal-id="proposal.id"
            :feedback-id="proposal.feedback_id"
          />
        </Proposal>
      </div>
    </div>
  </div>
</template>

<script>
import Proposal from './Proposal.vue';
import Comments from './comments/Comments';

export default {
  components: {
    Proposal,
    Comments,
  },
  props: {
    feedback: {
      type: Object,
      required: true,
    },
  },
  computed: {
    proposals() {
      let sortedProposals = {
        problems: [],
        primaries: [],
        alternatives: [],
      };
      this.feedback.proposals.forEach(proposal => {
        if (!proposal.solution) {
          sortedProposals.problems.push(proposal);
        } else if (proposal.primary) {
          sortedProposals.primaries.push(proposal);
        } else {
          sortedProposals.alternatives.push(proposal);
        }
      });
      return sortedProposals;
    },
  },
};
</script>
