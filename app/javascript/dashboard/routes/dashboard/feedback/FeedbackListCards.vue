<template>
  <div class="conversations-list-container">
    <div class="active-container">
      <div v-for="(feedback, index) in feedbackList" :key="feedback.id">
        <feedback-list-card-body :feedback="feedback" :index="index" />
      </div>
      <div
        v-show="feedbackList.length === 0"
        class="no-evaluations text-center"
      >
        <p>{{ details.emptyMessage }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import FeedbackListCardBody from './FeedbackListCardBody';

export default {
  components: {
    FeedbackListCardBody,
  },
  props: {
    feedbackList: {
      type: Array,
      require: true,
      default: () => [],
    },
  },
  computed: {
    ...mapGetters({
      feedbackStatusFilter: 'feedback/getFeedbackStatus',
    }),
    details() {
      return {
        emptyMessage: 'No feedback items within this list.',
      };
    },
  },
};
</script>

<style scoped lang="scss">
.no-evaluations {
  p {
    margin-top: 8rem;
    margin-bottom: 8rem;
  }
}

.active-container {
  background: white;
  padding-bottom: 5%;
}

.conversations-list-container {
  background: transparent;
}
</style>
