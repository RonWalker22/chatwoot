<template>
  <div class="feedback-item">
    <div v-if="!uiFlags.fetchingItem">
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
          />
        </div>
      </div>
      <Comments :posts="feedback.posts" />
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
