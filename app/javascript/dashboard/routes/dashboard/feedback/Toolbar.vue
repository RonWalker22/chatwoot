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
      <transition name="menu-slide">
        <div
          v-if="showMoveOptionsMenu"
          v-on-clickaway="showMoveOptions"
          class="dropdown-pane top"
        >
          <ul class="vertical dropdown menu">
            <li
              v-for="(move, index) in getMoves"
              :key="index"
              @click="updateStatus(move.name)"
            >
              <button class="button large expanded">
                <i :class="move.icon" aria-hidden="true"> </i>
                <span class="action-text">to {{ move.name }}</span>
              </button>
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
          <button class="button large" @click.prevent="showMoveOptions()">
            <i class="ion-paper-airplane" aria-hidden="true"> </i>
            <span class="action-text">Move</span>
          </button>
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

export default {
  components: {
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
      showMoveOptionsMenu: false,
      moves: [
        { name: 'review', icon: 'ion-paper-airplane' },
        { name: 'active', icon: 'ion-paper-airplane' },
        { name: 'resolved', icon: 'ion-paper-airplane' },
      ],
    };
  },
  computed: {
    isSupported() {
      return this.evaluation === 'support';
    },
    isRejected() {
      return this.evaluation === 'reject';
    },
    getMoves() {
      return this.moves.filter(move => {
        return move.name !== this.feedbackStatus;
      });
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
    showMoveOptions() {
      this.showMoveOptionsMenu = !this.showMoveOptionsMenu;
    },
    showMoreOptions() {
      this.showMoreOptionsMenu = !this.showMoreOptionsMenu;
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
