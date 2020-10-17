<template>
  <div class="columns medium-12">
    <section class="app-content columns">
      <div class="medium-4 columns feedback-list">
        <FeedbackList />
      </div>
      <div class="medium-8 columns hate feedback-item">
        <FeedbackItem v-if="feedbackPresent" :feedback-id="feedbackId" />
        <div v-else class="text-center img-container">
          <img
            src="~dashboard/assets/images/feature-request.svg"
            alt="No Feedback"
            class="feature-request"
          />
          <p>Select a feedback item from the left panel</p>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import FeedbackItem from './FeedbackItem';
import FeedbackList from './FeedbackList';
export default {
  components: {
    FeedbackItem,
    FeedbackList,
  },
  props: {
    feedbackId: {
      type: [String, Number],
      default: -1,
    },
  },
  computed: {
    feedbackPresent() {
      return this.feedbackId !== -1;
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~dashboard/assets/scss/variables';
@import '~dashboard/assets/scss/mixins';

.feedback-list {
  background: white;
  overflow-y: scroll;
}

.feedback-item {
  background: #f4f6fb;
  overflow-y: auto;
}

.feature-request {
  max-width: 40em;
  margin-top: 20em;
}

.img-container {
  margin-top: auto;
  margin-bottom: auto;
  p {
    font-size: 2rem;
  }
}
</style>
