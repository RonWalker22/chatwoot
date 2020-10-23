<template>
  <div>
    <div class="row">
      <div class="columns">
        <Proposal
          v-for="(proposal, index) in feedback.proposals"
          :key="proposal.id"
          :index="index"
          :proposal="proposal"
        />
      </div>
    </div>
  </div>
</template>

<script>
import Proposal from './Proposal.vue';

export default {
  components: {
    Proposal,
  },
  props: {
    feedback: {
      type: Object,
      required: true,
    },
  },
};
</script>
