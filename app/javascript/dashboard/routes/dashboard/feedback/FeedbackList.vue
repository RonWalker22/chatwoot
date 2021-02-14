<template>
  <div class="feedback-list-container">
    <div class="row title-row align-justify">
      <div class="columns">
        <div class="row">
          <div class="column">
            <h1 class="page-title">
              Feedback
            </h1>
          </div>
          <div class="column shrink">
            <select
              v-if="selectStatusOptions.length > 1"
              v-model="selectStatus"
              class="select-status"
              @change="onFilterChange()"
            >
              <option
                v-for="option in selectStatusOptions"
                :key="option"
                :value="option"
              >
                {{ option }}
              </option>
            </select>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="column shrink">
        <NewFeedback />
      </div>
    </div>
    <div v-if="!uiFlags.fetchingList">
      <div v-if="isAdmin" class="row align-center">
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
      <feedback-list-cards :feedback-list="feedbackList" />
    </div>
    <div v-else class="text-center">
      <spinner :size="'mega'"></spinner>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import Spinner from 'shared/components/Spinner.vue';
import NewFeedback from './NewFeedback';
import FeedbackListCards from './FeedbackListCards';
import router from '../../../routes';
import { frontendURL, feedbackUrl } from '../../../helper/URLHelper';

export default {
  components: {
    Spinner,
    NewFeedback,
    FeedbackListCards,
  },
  data() {
    return {
      selectStatus: '',
    };
  },
  computed: {
    ...mapGetters({
      feedbackList: 'feedback/getAllFeedback',
      uiFlags: 'feedback/getUIFlags',
      selectedStatusTabIndex: 'feedback/getSelectedStatusTabIndex',
      feedbackStatus: 'feedback/getFeedbackStatus',
      statusTabs: 'feedback/getStatusTabs',
      currentRole: 'getCurrentRole',
      accountId: 'getCurrentAccountId',
    }),
    isAdmin() {
      return this.currentRole === 'administrator';
    },
    selectStatusOptions() {
      // eslint-disable-next-line vue/no-side-effects-in-computed-properties
      this.selectStatus = this.feedbackStatus.filter;
      return this.feedbackStatus.options;
    },
  },
  methods: {
    ...mapActions('feedback', [
      'resetSelectedFeedbackId',
      'resetBulkEditCheckStatus',
      'setSelectedStatusTabFilter',
    ]),
    onTabChange(selectedTabIndex) {
      this.$store.dispatch(
        'feedback/setSelectedStatusTabIndex',
        selectedTabIndex
      );
      this.resetOnChange();
    },
    onFilterChange() {
      let filter = {
        index: this.selectedStatusTabIndex,
        value: this.selectStatus,
      };
      this.$store.dispatch('feedback/setSelectedStatusTabFilter', filter);
      this.resetOnChange();
    },
    resetOnChange() {
      this.resetSelectedFeedbackId();
      this.resetBulkEditCheckStatus();
      const path = feedbackUrl({
        accountId: this.accountId,
      });
      router.push({ path: frontendURL(path) });
    },
  },
};
</script>

<style scoped lang="scss">
@import '~dashboard/assets/scss/variables';
@import '~dashboard/assets/scss/mixins';

.title-row {
  margin-bottom: 1.5em;
}

.conversations-list-container {
  background: transparent;
}

.feedback-list-container {
  background: white;
  padding: 1.5em;
}

.select-status {
  font-size: 1.2rem;
  width: auto;
  border: 1px solid $color-border;
  margin-bottom: 0;
  height: inherit;
}
</style>
