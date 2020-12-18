<template>
  <div>
    <div v-if="!uiFlags.fetchingItem" class="fb-item">
      <div class="row align-justify action-row">
        <div class="column shrink">
          <NewSolution :feedback-id="feedback.id" />
        </div>
        <div class="column shrink">
          <EditFeedback :feedback-id="feedback.id" />
        </div>
      </div>
      <h1 class="feedback-title text-center">
        {{ feedback.title }}
      </h1>
      <div class="column shrink">
        <p>Status: {{ feedback.status.toUpperCase() }}</p>
      </div>
      <Proposals :feedback="feedback" />
      <Comments
        :thread-id="feedback.thread"
        :feedback-id="feedback.id"
        :main-board="true"
      />
      <Toolbar :feedback="feedback" />
    </div>
    <div v-else class="text-center">
      <spinner :size="'large'"></spinner>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import Proposals from './Proposals';
import Comments from './Comments';
import Spinner from 'shared/components/Spinner.vue';
import Toolbar from './Toolbar';
import EditFeedback from './EditFeedback.vue';
import NewSolution from './NewSolution.vue';

export default {
  components: {
    Proposals,
    Comments,
    Spinner,
    Toolbar,
    EditFeedback,
    NewSolution,
  },
  props: {
    feedbackId: {
      type: [String, Number],
      default: 0,
    },
  },
  computed: {
    feedback() {
      return this.$store.getters['feedback/getFeedbackItem'](this.feedbackId);
    },
    ...mapGetters({
      uiFlags: 'feedback/getUIFlags',
    }),
  },
  mounted() {
    this.$store.dispatch('feedback/fetchFeedbackItem', this.feedbackId);
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
</style>
