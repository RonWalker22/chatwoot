<template>
  <div>
    <div class="row title-row">
      <div class="columns small-8">
        <h1 class="page-title">
          Feedback
        </h1>
      </div>
      <div class="columns">
        <NewFeedback />
      </div>
    </div>
    <div class="row align-center">
      <div class="columns shrink">
        <woot-tabs
          :index="selectedStatusTabIndex"
          class="tab--chat-type"
          @change="onTabChange"
        >
          <woot-tabs-item
            v-for="tab in statusTabs"
            :key="tab.key"
            :name="tab.name"
            :show-badge="false"
            :data-test-id="'feedback-tab-' + tab.key"
          />
        </woot-tabs>
      </div>
    </div>
    <div v-if="!uiFlags.fetchingList" class="conversations-list">
      <div
        v-for="feedback in feedbackList"
        :key="feedback.id"
        @click="cardClick(feedback.id, feedback.account)"
      >
        <div
          class="card"
          :class="{
            'card-active': selectedFeedbackId == feedback.id,
          }"
          data-test-id="feedback-list-card"
        >
          <div class="card-section">
            <p
              class="h6"
              :class="'kind-' + feedback.kind"
              data-test-id="feedback-list-type"
            >
              {{ feedback.kind }}
            </p>
            <p data-test-id="feedback-list-title">
              {{ feedback.title }}
            </p>
          </div>
        </div>
      </div>
    </div>
    <div v-else class="text-center">
      <spinner :size="'large'"></spinner>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import router from '../../../routes';
import { frontendURL, feedbackUrl } from '../../../helper/URLHelper';
import Spinner from 'shared/components/Spinner.vue';
import NewFeedback from './NewFeedback';

export default {
  components: {
    Spinner,
    NewFeedback,
  },
  computed: {
    ...mapGetters({
      feedbackList: 'feedback/getAllFeedback',
      uiFlags: 'feedback/getUIFlags',
      selectedFeedbackId: 'feedback/getSelectedFeedbackId',
      feedbackStatusFilter: 'feedback/getfeedbackStatusFilter',
      selectedStatusTabIndex: 'feedback/getSelectedStatusTabIndex',
      statusTabs: 'feedback/getStatusTabs',
    }),
    currentFeedbackId() {
      return this.$router.currentRoute.params.feedback_id;
    },
  },
  methods: {
    cardClick(feedbackId, accountId) {
      this.$store.dispatch('feedback/setSelectedFeedbackId', feedbackId);
      this.updateFeedback(feedbackId);
      const path = feedbackUrl({
        accountId: accountId,
        id: feedbackId,
      });
      router.push({ path: frontendURL(path) });
    },
    updateFeedback(id) {
      this.$store.dispatch('feedback/fetchFeedbackItem', id);
    },
    onTabChange(selectedTabIndex) {
      this.$store.dispatch(
        'feedback/setSelectedStatusTabIndex',
        selectedTabIndex
      );
    },
  },
};
</script>

<style scoped lang="scss">
@import '~dashboard/assets/scss/variables';
@import '~dashboard/assets/scss/mixins';

$xy-grid: true;

.card {
  margin-bottom: 2em;
  border: none;
  :hover {
    background: #f4f6fb;
    cursor: pointer;
  }
}

.card-active {
  background: #f4f6fb;
}

.card-section {
  .h6 {
    background: none;
    color: $color-woot;
  }

  .kind-bug {
    color: firebrick;
  }

  .kind-general {
    color: black;
  }
}

.title-row {
  padding: 1.5em;
}

.seen-title {
  font-size: 1.5rem;
}
</style>
