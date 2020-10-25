<template>
  <div>
    <div class="row">
      <div class="columns">
        <Proposal
          v-for="(proposal, index) in feedback.proposals"
          :key="proposal.id"
          :index="index"
          :proposal="proposal"
        >
          <Comments
            :thread-id="proposal.thread"
            :main-board="false"
            :feedback-id="proposal.feedback_id"
          />
        </Proposal>
      </div>
    </div>
  </div>
</template>

<script>
import Proposal from './Proposal.vue';
import Comments from './Comments';

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
};
</script>
