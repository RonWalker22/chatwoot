<template>
  <div class="columns medium-12">
    <section class="app-content columns">
      <div class="medium-4 columns feedback-list">
        <FeedbackList />
      </div>
      <div
        class="medium-8 columns hate feedback-item"
        :class="{ 'fb-edit': bulkEditActive }"
      >
        <div v-if="bulkEditActive">
          <bulk-edit-toolbar />
        </div>
        <div v-else-if="feedback.id && !bulkEditActive">
          <FeedbackItem
            v-if="!uiFlags.fetchingItem && !uiFlags.creatingItem"
            :feedback="feedback"
          />
          <div v-else class="text-center">
            <spinner :size="'mega'" class="text-center"></spinner>
          </div>
        </div>
        <div v-else class="text-center img-container">
          <img
            src="~dashboard/assets/images/feature-request.svg"
            alt="No Feedback"
            class="feature-request"
          />
          <p>Select a feedback item from the left panel</p>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import FeedbackItem from './feedbackItem/FeedbackItem';
import FeedbackList from './feedbackList/FeedbackList';
import BulkEditToolbar from './BulkEditToolbar';
import Spinner from 'shared/components/Spinner.vue';

export default {
  components: {
    FeedbackItem,
    FeedbackList,
    Spinner,
    BulkEditToolbar,
  },
  props: {
    feedbackId: {
      type: [String, Number],
      default: 0,
    },
  },
  computed: {
    ...mapGetters({
      uiFlags: 'feedback/getUIFlags',
      bulkEditActive: 'feedback/getBulkEditActive',
    }),
    feedback() {
      return this.$store.getters['feedback/getFeedbackItem'](this.feedbackId);
    },
    defaultTabIndex() {
      let index = 0;
      this.$store.getters['feedback/getStatusTabs'].forEach((statusTab, i) => {
        if (statusTab.name === 'Review') {
          index = i;
        }
      });
      return index;
    },
  },
  created() {
    this.$store.dispatch('feedback/fetchAllFeedback');
  },
  mounted() {
    if (this.feedbackId !== 0) {
      this.$store.dispatch('feedback/fetchFeedbackItem', this.feedbackId);
      this.$store.dispatch('feedback/setSelectedFeedbackId', this.feedbackId);
    } else {
      this.$store.dispatch(
        'feedback/setSelectedStatusTabIndex',
        this.defaultTabIndex
      );
    }
  },
};
</script>

<style lang="scss" scoped>
@import '~dashboard/assets/scss/variables';
@import '~dashboard/assets/scss/mixins';

.feedback-list {
  overflow-y: scroll;
}

.feedback-item {
  background: white;
  overflow-y: scroll;
}
.fb-edit {
  background: #f4f6fb;
}

.feature-request {
  max-width: 40em;
  margin-top: 20em;
}

.img-container {
  margin-top: auto;
  margin-bottom: auto;
  p {
    font-size: 2rem;
  }
}
</style>

<style lang="scss">
body {
  overflow-y: hidden;
}
</style>
