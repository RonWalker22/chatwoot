<template>
  <div class="feedback-item">
    <div v-if="!uiFlags.fetchingItem">
      <div class="row">
        <div class="column shrink">
          <p>Status: {{ feedback.status.toUpperCase() }}</p>
        </div>
        <div class="column" />
        <div class="column shrink">
          <button class="button">
            New Solution
          </button>
        </div>
      </div>
      <h1 class="feedback-title text-center">
        {{ feedback.title }}
      </h1>
      <Proposals :feedback="feedback" />
      <div class="row align-center">
        <div class="columns shrink">
          <Toolbar
            :feedback-user-id="feedback.feedback_user_id"
            :evaluation="feedback.evaluation"
            :feedback-id="feedback.id"
            :feedback-status="feedback.status"
          />
        </div>
      </div>
      <Comments
        :thread-id="feedback.thread"
        :feedback-id="feedback.id"
        :main-board="true"
      />
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
import Toolbar from './Toolbar';
import Spinner from 'shared/components/Spinner.vue';

export default {
  components: {
    Proposals,
    Comments,
    Spinner,
    Toolbar,
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
.card-divider {
  background: transparent;
  h4 {
    text-align: center;
  }
}

.feedback-item {
  padding: 4rem;
}

.feedback-title {
  font-size: 2rem;
}
</style>
