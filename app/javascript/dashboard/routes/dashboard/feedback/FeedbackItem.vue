<template>
  <div>
    <div v-if="!uiFlags.fetchingItem" class="fb-item">
      <div class="row align-justify action-row">
        <div class="column shrink">
          <NewSolution :feedback-id="feedback.id" />
        </div>
        <div class="column shrink">
          <p>
            Status:
            <span data-test-id="feedback-status">{{ feedback.status }}</span>
            - Type:
            <span data-test-id="feedback-type">{{ feedback.kind }}</span>
          </p>
        </div>
        <div class="column shrink">
          <EditFeedback :feedback-id="feedback.id" />
        </div>
      </div>
      <h1 class="feedback-title text-center" data-test-id="feedback-title">
        {{ feedback.title }}
      </h1>
      <Proposals :feedback="feedback" />
      <Comments
        :thread-id="feedback.thread"
        :feedback-id="feedback.id"
        :main-board="true"
      />
      <Toolbar :feedback="feedback" />
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import Proposals from './Proposals';
import Comments from './Comments';
import Toolbar from './Toolbar';
import EditFeedback from './EditFeedback.vue';
import NewSolution from './NewSolution.vue';

export default {
  components: {
    Proposals,
    Comments,
    Toolbar,
    EditFeedback,
    NewSolution,
  },
  props: {
    feedback: {
      type: Object,
      required: true,
    },
  },
  computed: {
    ...mapGetters({
      uiFlags: 'feedback/getUIFlags',
      statusTabs: 'feedback/getStatusTabs',
    }),
  },
  mounted() {
    this.statusTabs.forEach((statusObject, i) => {
      if (statusObject.key === this.feedback.status) {
        this.$store.dispatch('feedback/setSelectedStatusTabIndex', i);
      }
    });
  },
};
</script>

<style scoped lang="scss">
@import '~dashboard/assets/scss/variables';

.card-divider {
  background: transparent;
  h4 {
    text-align: center;
  }
}

.fb-item {
  padding: 4rem;
}

.feedback-title {
  font-size: 2rem;
}

.action-row {
  margin-bottom: 4rem;
}

.card-section {
  p {
    text-align: left !important;
  }
}
</style>
