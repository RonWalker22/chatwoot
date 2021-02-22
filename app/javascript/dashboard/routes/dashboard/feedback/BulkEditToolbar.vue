<template>
  <div class="bulk-edit-container">
    <div class="row align-justify">
      <button
        class="button clear bulk-edit-cancel-btn"
        @click="resetBulkEditCheckStatus()"
      >
        cancel edit
      </button>
      <button class="button clear bulk-edit-cancel-btn" @click="bulkDelete()">
        delete all
      </button>
    </div>
    <div class="row bulk-edit-actions-box">
      <div class="column action-column medium-12 large-expand">
        <h3 class="text-center">
          <span>Final Judgment</span>
        </h3>
        <div class="row align-center">
          <button
            class="button large-expand"
            @click="bulkUpdateStatus('reject')"
          >
            Reject
          </button>
          <button
            class="button large-expand"
            @click="bulkUpdateStatus('accept')"
          >
            Accept
          </button>
        </div>
      </div>
      <div class="column action-column medium-12 large-expand">
        <h3 class="text-center">
          <span>Move To</span>
        </h3>
        <div class="row align-center">
          <button
            v-for="(status, index) in moveToStatusTabs"
            :key="index"
            class="button large-expand move-to-btn"
            @click="bulkUpdateStatus(status.value)"
          >
            {{ status.name }}
          </button>
        </div>
      </div>
      <div class="column action-column medium-12 large-expand">
        <h3 class="text-center">
          <span>Change Type</span>
        </h3>
        <div class="row align-center">
          <button
            class="button large-expand"
            @click="bulkUpdateKind('request')"
          >
            Feature
          </button>
          <button class="button large-expand" @click="bulkUpdateKind('bug')">
            Bug
          </button>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="column small-12">
        <div v-if="feedback" class="bulk-edit-actions-box">
          <label>
            Title
            <textarea
              :value="feedback.title"
              @input="title = $event.target.value"
            />
          </label>
          <button class="button" @click="updateTitle()">
            Update
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import { frontendURL, feedbackUrl } from '../../../helper/URLHelper';
import router from '../../../routes';

export default {
  data() {
    return {
      title: '',
      details: '',
    };
  },
  computed: {
    ...mapGetters({
      statusTabs: 'feedback/getStatusTabs',
      mainStatusTabs: 'feedback/getStatusTabs',
      ids: 'feedback/getBulkSelectedIds',
    }),
    moveToStatusTabs() {
      return [
        { name: 'upcoming', value: 'upcoming' },
        { name: 'review', value: 'review' },
        { name: 'preview', value: 'preview' },
      ];
    },
    feedback() {
      let id = this.ids[0];
      if (this.ids.length === 1) {
        let fb = this.$store.getters['feedback/getFeedbackItem'](id);
        return fb;
      }
      return null;
    },
  },
  methods: {
    ...mapActions('feedback', [
      'resetBulkEditCheckStatus',
      'updateMultipleFeedbacks',
      'deleteMultipleFeedbacks',
      'updateFeedback',
    ]),
    bulkUpdateStatus(status) {
      const ids = this.ids;
      this.updateMultipleFeedbacks({
        payload: {
          feedback: {
            status: status,
          },
          ids: ids,
        },
      });
      this.resetBulkEditCheckStatus();
    },
    bulkUpdateKind(kind) {
      const ids = this.ids;
      this.updateMultipleFeedbacks({
        payload: {
          feedback: {
            kind: kind,
          },
          ids: ids,
        },
      });
      this.resetBulkEditCheckStatus();
    },
    bulkDelete() {
      const ids = this.ids;
      this.deleteMultipleFeedbacks({
        payload: {
          ids: ids,
        },
      });
      this.resetBulkEditCheckStatus();
      this.$store.dispatch('feedback/resetSelectedFeedbackId');
      const path = feedbackUrl({
        accountId: this.accountId,
      });
      router.push({ path: frontendURL(path) });
    },
    updateTitle() {
      let payload = {
        payload: { feedback: { title: this.title } },
        id: this.feedback.id,
      };
      this.updateFeedback(payload);
      this.resetBulkEditCheckStatus();
    },
  },
};
</script>

<style scoped lang="scss">
@import '~dashboard/assets/scss/variables';

.bulk-edit-actions-box {
  padding: 2rem;
  padding-top: 0;
  margin-top: 2rem;
  margin-left: 2rem;
  background: #0072ce;
  .button {
    margin-right: 0.5rem;
    margin-top: 0.5rem;
    color: white;
    background: #195f97;
    &:hover {
      background: #0a3c64;
    }
  }
}

.bulk-edit-container {
  margin: 5rem;
}

.bulk-edit-cancel-btn {
  text-decoration: underline;
}

.delete-btn {
  background: maroon;
  &:hover {
    background: firebrick;
  }
}

h3,
label {
  color: white;
  font-size: 2rem;
  margin-bottom: 1rem;
}

label {
  padding-top: 2rem;
}

textarea {
  margin-top: 1rem;
}

.action-column {
  margin-top: 2rem;
  margin-left: 2rem;
}

.move-to-btn {
  text-transform: capitalize;
}
</style>
