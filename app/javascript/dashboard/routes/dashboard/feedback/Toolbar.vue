<template>
  <div class="toolbar-container">
    <div class="card toolbar-card">
      <div class="row align-center">
        <div class="columns shrink">
          <button
            class="button large"
            :class="[isSupported ? 'support-selected' : 'pick-unselected']"
            @click="supportFeedback"
          >
            <i class="ion-thumbsup" aria-hidden="true"> </i>
            <span class="action-text">Support</span>
          </button>
        </div>
        <div class="columns shrink">
          <button
            class="button large"
            :class="[isRejected ? 'reject-selected' : 'pick-unselected']"
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
      return this.feedback.evaluation === 'support';
    },
    isRejected() {
      return this.feedback.evaluation === 'reject';
    },
  },
  methods: {
    ...mapActions('feedback', ['setFeedbackEvaluation', 'createFeedbackUser']),
    supportFeedback() {
      if (this.feedback.evaluation === 'support') {
        this.resetFeedbackEvaluation();
      } else {
        this.sendEvaluation('support');
      }
    },
    rejectFeedback() {
      if (this.feedback.evaluation === 'reject') {
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
        },
        id: this.feedback.feedback_user_id,
        feedbackUser: this.checkFeedbackUser(),
        feedback_id: this.feedback.id,
      });
    },
    checkFeedbackUser() {
      return this.feedback.feedback_user_id !== 0;
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
}

.action-text {
  display: block;
  margin-top: 0.5rem;
}

.button {
  background-color: transparent;
  color: black;
}

.support-selected {
  background-color: $color-woot;
  color: white;
}

.reject-selected {
  background-color: firebrick;
  color: white;
}

.pick-unselected {
  background-color: #f5f5f5;
  color: black;
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
  max-width: 24rem;
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
