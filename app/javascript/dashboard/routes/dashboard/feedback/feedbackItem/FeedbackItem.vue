<template>
  <div>
    <div v-if="!uiFlags.fetchingItem" class="fb-item">
      <div class="row align-justify action-row">
        <div class="column small-2">
          <NewSolution :feedback-id="feedback.id" />
        </div>
        <div class="column small-2">
          <div v-if="isAdmin">
            <button
              class="button hollow small"
              data-test-id="edit-feedback-btn"
              @click="editFeedback"
            >
              Edit Feedback
            </button>
          </div>
        </div>
      </div>
      <h1 class="feedback-title text-center" data-test-id="feedback-title">
        {{ feedback.title }}
      </h1>
      <Proposals :feedback="feedback" />
      <Toolbar :feedback="feedback" />
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import Proposals from '../proposals/Proposals';
import Toolbar from './Toolbar';
import NewSolution from '../proposals/NewSolution';

export default {
  components: {
    Proposals,
    Toolbar,
    NewSolution,
  },
  props: {
    feedback: {
      type: Object,
      required: true,
    },
  },
  computed: {
    ...mapGetters({
      uiFlags: 'feedback/getUIFlags',
      statusTabs: 'feedback/getStatusTabs',
      currentRole: 'getCurrentRole',
      feedbackList: 'feedback/getAllFeedback',
      bulkSelectIndex: 'feedback/getBulkSelectIndex',
    }),
    isAdmin() {
      return this.currentRole === 'administrator';
    },
  },
  mounted() {
    this.statusTabs.forEach((statusObject, i) => {
      if (statusObject.key === this.feedback.status) {
        this.$store.dispatch('feedback/setSelectedStatusTabIndex', i);
      }
    });
  },
  methods: {
    ...mapActions('feedback', ['setBulkEditCheckStatus', 'setBulkSelectIndex']),
    editFeedback() {
      for (let i = 0; i < this.feedbackList.length; i += 1) {
        if (this.feedbackList[i].id === this.feedback.id) {
          this.setBulkEditCheckStatus([
            {
              index: i,
              payload: true,
            },
          ]);
          this.setBulkSelectIndex({
            previous: this.bulkSelectIndex.previous,
            current: i,
          });
          break;
        }
      }
    },
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

h1 {
  font-size: $font-size-large;
}

.menu-vx {
  position: fixed;
  top: 50%;
  -webkit-transform: translateY(-50%);
  -ms-transform: translateY(-50%);
  transform: translateY(-50%);
  height: 100%;
  display: grid;
  margin: 0;
  margin-left: 1rem;
  li {
    a {
      color: #6e767d;
    }
  }
}
</style>
