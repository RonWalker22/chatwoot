<template>
  <div v-if="reviewStatus" class="toolbar-container">
    <div class="card toolbar-card">
      <div class="row align-center">
        <div class="columns small-6">
          <button
            class="button large expanded support-btn"
            :class="[isSupported ? 'support-selected' : 'pick-unselected']"
            data-test-id="support-feedback-btn"
            @click="supportFeedback"
          >
            <i class="ion-thumbsup" aria-hidden="true"> </i>
            <span class="action-text">Support</span>
          </button>
        </div>
        <div class="columns small-6">
          <button
            class="button large expanded reject-btn"
            :class="[isRejected ? 'reject-selected' : 'pick-unselected']"
            data-test-id="reject-feedback-btn"
            @click="rejectFeedback"
          >
            <i class="ion-thumbsdown" aria-hidden="true"> </i>
            <span class="action-text">Reject</span>
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
    feedback: {
      type: Object,
      default() {
        return {};
      },
    },
  },
  computed: {
    isSupported() {
      const evaluation = this.feedback.evaluation;
      return evaluation === 'support';
    },
    isRejected() {
      const evaluation = this.feedback.evaluation;
      return evaluation === 'reject';
    },
    reviewStatus() {
      return this.feedback.status === 'review';
    },
  },
  methods: {
    ...mapActions('feedback', ['setFeedbackEvaluation', 'createFeedbackUser']),
    supportFeedback() {
      const evaluation = this.feedback.evaluation;
      if (evaluation === 'support') {
        this.resetFeedbackEvaluation();
      } else {
        this.sendEvaluation('support');
      }
    },
    rejectFeedback() {
      const evaluation = this.feedback.evaluation;
      if (evaluation === 'reject') {
        this.resetFeedbackEvaluation();
      } else {
        this.sendEvaluation('reject');
      }
    },
    resetFeedbackEvaluation() {
      this.sendEvaluation('undecided');
    },
    sendEvaluation(kind) {
      this.setFeedbackEvaluation({
        payload: {
          feedback_user: {
            evaluation: kind,
          },
          feedback_id: this.feedback.id,
        },
        id: this.feedback.feedback_user_id,
      });
    },
  },
};
</script>

<style scoped lang="scss">
@import '~dashboard/assets/scss/variables';

.toolbar-card {
  border-radius: 25px;
  background: transparent;
  display: inline-block;
  border-color: transparent;
  width: inherit;
}

.action-text {
  display: block;
  margin-top: 0.5rem;
}

.button {
  background-color: transparent;
}

.support-selected {
  background-color: $color-woot;
  color: white;
}

.reject-selected {
  background-color: #b22222;
  color: white;
}

.pick-unselected {
  background-color: #f5f5f5;
  color: black;
}

.reject-btn {
  border-radius: 0% 20% 20% 0%;
}

.support-btn {
  border-radius: 20% 0% 0% 20%;
}

.dropdown-pane {
  bottom: 30px;
  top: unset;
}

.bottom-nav {
  border-top: none;
}

.toolbar-container {
  position: sticky;
  width: 37rem;
  margin-left: auto;
  margin-right: auto;
  bottom: 0;
  padding: 1rem 0;
  z-index: 8;
}

.inline-flex {
  display: inline-flex;
}

.ion-chevron-down {
  font-size: 1rem;
  padding: 0rem 1rem 1rem 1rem;
}
</style>
