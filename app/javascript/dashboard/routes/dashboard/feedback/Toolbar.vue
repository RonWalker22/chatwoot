<template>
  <div>
    <div class="card toolbar-card">
      <div class="row align-center">
        <div class="columns shrink">
          <button
            class="button large"
            :class="{ evaluated: isSupported }"
            @click="supportFeedback"
          >
            <i class="ion-thumbsup" aria-hidden="true"> </i>
            <span class="action-text">Support</span>
          </button>
        </div>
        <div class="columns shrink">
          <button
            class="button large"
            :class="{ evaluated: isRejected }"
            @click="rejectFeedback"
          >
            <i class="ion-thumbsdown" aria-hidden="true"> </i>
            <span class="action-text">Reject</span>
          </button>
        </div>
        <div class="columns shrink">
          <button class="button large">
            <i class="ion-paper-airplane" aria-hidden="true"> </i>
            <span class="action-text">Move</span>
          </button>
        </div>
        <div class="columns shrink">
          <button class="button large">
            <i class="ion-more" aria-hidden="true"> </i>
            <span class="action-text">More</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  props: {
    feedbackUserId: {
      type: [String, Number],
      default: 0,
    },
    evaluation: {
      type: String,
      default: 'undecided',
    },
    feedbackId: {
      type: [String, Number],
      default: 0,
    },
  },
  computed: {
    isSupported() {
      return this.evaluation === 'support';
    },
    isRejected() {
      return this.evaluation === 'reject';
    },
  },
  methods: {
    ...mapActions('feedback', ['setFeedbackEvaluation', 'createFeedbackUser']),
    supportFeedback() {
      this.sendEvaluation('support', this.checkFeedbackUser());
    },
    rejectFeedback() {
      this.sendEvaluation('reject', this.checkFeedbackUser());
    },
    resetFeedbackEvaluation() {
      this.sendEvaluation('undecided', this.checkFeedbackUser());
    },
    sendEvaluation(kind, feedbackUserExist) {
      if (this.evaluation !== kind) {
        this.setFeedbackEvaluation({
          payload: {
            feedback_user: {
              evaluation: kind,
            },
          },
          id: this.feedbackUserId,
          feedbackUser: feedbackUserExist,
          feedback_id: this.feedbackId,
        });
      }
    },
    checkFeedbackUser() {
      return this.feedbackUserId !== 0;
    },
  },
};
</script>

<style scoped lang="scss">
@import '~dashboard/assets/scss/variables';

.toolbar-card {
  border-radius: 25px;
  background: whitesmoke;
  display: inline-block;
  border-color: transparent;
}

.action-text {
  display: block;
  margin-top: 0.5rem;
}

.button {
  background-color: transparent;
  color: black;
}

.evaluated {
  background-color: $color-woot;
  color: white;
}
</style>
