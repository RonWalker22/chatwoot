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
          :index="selectedTabIndex"
          class="tab--chat-type"
          @change="onTabChange"
        >
          <woot-tabs-item
            v-for="tab in tabs"
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
        <div class="card">
          <div class="card-section">
            <p
              class="h6"
              :class="'kind-' + feedback.kind"
              data-test-id="feedback-list-type"
            >
              {{ formatKind(feedback.kind) }}
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
  data() {
    return {
      tabs: [
        {
          key: 'review',
          name: 'Review',
        },
        {
          key: 'active',
          name: 'Active',
        },
        {
          key: 'resolved',
          name: 'Resolved',
        },
      ],
      selectedTabIndex: 0,
    };
  },
  computed: {
    ...mapGetters({
      feedbackList: 'feedback/getAllFeedback',
      uiFlags: 'feedback/getUIFlags',
    }),
    FeedbackFilters() {
      return {
        status: this.activeStatus,
      };
    },
    FeedbackFilterName() {
      return this.tabs[this.selectedTabIndex].key;
    },
  },
  created() {
    this.$store.dispatch('feedback/fetchAllFeedback');
  },
  mounted() {
    this.onTabChange(0);
  },
  methods: {
    formatKind(kind) {
      switch (kind) {
        case 'request':
          return 'Request';
        case 'bug':
          return 'Bug';
        default:
          return 'General';
      }
    },
    cardClick(feedbackId, accountId) {
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
    updateFeedbackFilter() {
      this.$store.dispatch(
        'feedback/setFeedbackFilter',
        this.FeedbackFilterName
      );
    },
    onTabChange(selectedTabIndex) {
      if (
        selectedTabIndex === 0 ||
        this.selectedTabIndex !== selectedTabIndex
      ) {
        this.selectedTabIndex = selectedTabIndex;
        this.$store.dispatch(
          'feedback/setFeedbackFilter',
          this.FeedbackFilterName
        );
      }
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
.card-section {
  .h6 {
    text-transform: capitalize;
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
