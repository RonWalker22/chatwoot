<template>
  <div>
    <div class="bottom-nav">
      <transition name="menu-slide">
        <div
          v-if="showMoreOptionsMenu"
          v-on-clickaway="showMoreOptions"
          class="dropdown-pane top"
        >
          <ul class="vertical dropdown menu">
            <li>
              <EditFeedback :feedback-id="feedbackId" />
            </li>
          </ul>
        </div>
      </transition>
    </div>
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
          <NewSolution :feedback-id="feedbackId" />
        </div>
        <div class="columns shrink">
          <button class="button large" @click.prevent="showMoreOptions()">
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
import { mixin as clickaway } from 'vue-clickaway';
import EditFeedback from './EditFeedback.vue';
import NewSolution from './NewSolution.vue';

export default {
  components: {
    NewSolution,
    EditFeedback,
  },
  mixins: [clickaway],
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
    feedbackStatus: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      showMoreOptionsMenu: false,
      showNewSolution: false,
    };
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
    ...mapActions('feedback', [
      'setFeedbackEvaluation',
      'createFeedbackUser',
      'updateFeedback',
    ]),
    supportFeedback() {
      if (this.evaluation === 'support') {
        this.resetFeedbackEvaluation();
      } else {
        this.sendEvaluation('support');
      }
    },
    rejectFeedback() {
      if (this.evaluation === 'reject') {
        this.resetFeedbackEvaluation();
      } else {
        this.sendEvaluation('reject');
      }
    },
    resetFeedbackEvaluation() {
      this.sendEvaluation('undecided');
    },
    updateStatus(status) {
      this.sendStatus(status);
    },
    sendEvaluation(kind) {
      this.setFeedbackEvaluation({
        payload: {
          feedback_user: {
            evaluation: kind,
          },
        },
        id: this.feedbackUserId,
        feedbackUser: this.checkFeedbackUser(),
        feedback_id: this.feedbackId,
      });
    },
    sendStatus(status) {
      if (this.status !== status) {
        this.updateFeedback({
          payload: {
            feedback: {
              status: status,
            },
          },
          id: this.feedbackId,
        });
        this.showMoveOptions();
      }
    },
    checkFeedbackUser() {
      return this.feedbackUserId !== 0;
    },
    showMoreOptions() {
      this.showMoreOptionsMenu = !this.showMoreOptionsMenu;
    },
    toggleNewSolution() {
      this.showNewSolution = !this.showNewSolution;
    },
  },
};
</script>

<style scoped lang="scss">
@import '~dashboard/assets/scss/variables';

.toolbar-card {
  border-radius: 25px;
  background: white;
  display: inline-block;
  border-color: transparent;
}

.action-text {
  display: block;
  margin-top: 0.5rem;
}

.button {
  background-color: transparent;
  color: $color-woot;
}

.evaluated {
  background-color: $color-woot;
  color: white;
}
.dropdown-pane {
  bottom: 30px;
  top: unset;
}

.bottom-nav {
  border-top: none;
}
</style>
