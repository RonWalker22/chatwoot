<template>
  <div>
    <transition name="modal-fade">
      <div
        v-if="show"
        class="modal-mask"
        transition="modal"
        data-test-id="new-feedback-close-mask"
        @click="closeModal"
      >
        <div class="modal-container" @click.stop>
          <div class="modal-content">
            <div class="row">
              <h1 data-test-id="new-feedback-title">
                New Feedback
              </h1>
              <i
                class="ion-android-close modal--close"
                data-test-id="new-feedback-close-icon"
                @click="closeModal"
              >
              </i>
            </div>
            <form>
              <div class="row">
                <div class="small-7 columns">
                  <label>
                    Feedback Type
                    <select
                      v-model="payload.feedback.kind"
                      data-test-id="new-feedback-select-type"
                    >
                      <option value="selected disabled hidden">
                        Choose Feedback Type
                      </option>
                      <option
                        value="request"
                        data-test-id="new-feedback-select-type-option-request"
                      >
                        Feature Request
                      </option>
                      <option
                        value="general"
                        data-test-id="new-feedback-select-type-option-general"
                      >
                        General
                      </option>
                      <option
                        value="bug"
                        data-test-id="new-feedback-select-type-option-bug"
                      >
                        Bug Report
                      </option>
                    </select>
                  </label>
                  <label>
                    Inbox
                    <select
                      v-model="payload.feedback.inbox_id"
                      data-test-id="new-feedback-select-inbox"
                    >
                      <option
                        v-for="inbox in inboxList"
                        :key="inbox.id"
                        :value="inbox.id"
                        :data-test-id="`new-feedback-select-option-${inbox.id}`"
                      >
                        {{ inbox.name }}
                      </option>
                    </select>
                  </label>
                </div>
                <div class="small-12 columns">
                  <label>
                    Title
                    <input
                      v-model.trim="payload.feedback.title"
                      type="text"
                      data-test-id="new-feedback-input-title"
                    />
                  </label>
                  <label>
                    Problem
                    <textarea
                      v-model="payload.problem"
                      rows="4"
                      data-test-id="new-feedback-input-problem"
                    >
                    </textarea>
                  </label>
                  <label>
                    Solution
                    <textarea
                      v-model="payload.solution"
                      rows="4"
                      data-test-id="new-feedback-input-solution"
                    >
                    </textarea>
                  </label>
                </div>
              </div>
              <div class="modal-footer">
                <div class="medium-12 columns">
                  <button
                    class="button"
                    type="submit"
                    data-test-id="new-feedback-submit-btn"
                    @click.prevent="submitFeedback"
                  >
                    Submit
                  </button>
                  <button
                    class="button clear"
                    data-test-id="new-feedback-cancel-btn"
                    @click.prevent="CancelModal"
                  >
                    Cancel
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </transition>
    <woot-button
      class="expanded"
      variant="hollow primary small"
      data-test-id="new-feedback-btn"
      @click="openModal"
    >
      New Feedback
    </woot-button>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import router from '../../../../routes';
import { frontendURL, feedbackUrl } from '../../../../helper/URLHelper';

export default {
  data() {
    return {
      show: false,
      payload: {
        feedback: {
          title: '',
          kind: 'request',
          inbox_id: '',
        },
        problem: '',
        solution: '',
      },
    };
  },
  computed: {
    ...mapGetters({
      inboxList: 'inboxes/getInboxes',
      accountId: 'getCurrentAccountId',
    }),
  },
  methods: {
    ...mapActions('feedback', ['createFeedback']),
    CancelModal() {
      this.show = false;
      this.payload = this.resetFeedback();
    },
    resetFeedback() {
      return {
        feedback: {
          title: '',
          kind: 'request',
          inbox_id: '',
        },
        problem: '',
        solution: '',
      };
    },
    closeModal() {
      this.show = false;
    },
    openModal() {
      this.show = true;
    },
    getFeedbackArray() {
      return [
        {
          feedback: {
            title: this.payload.feedback.title,
            kind: this.payload.feedback.kind,
            inbox_id: this.payload.feedback.inbox_id,
          },
        },
        {
          proposal: {
            details: this.payload.problem,
            solution: false,
          },
        },
        {
          proposal: {
            details: this.payload.solution,
            solution: true,
          },
        },
      ];
    },
    submitFeedback() {
      this.closeModal();
      this.createFeedback(this.getFeedbackArray()).then(feedback => {
        this.payload = this.resetFeedback();
        this.$store.dispatch('feedback/setSelectedFeedbackId', feedback.id);
        const path = feedbackUrl({
          accountId: this.accountId,
          id: feedback.id,
        });
        this.$store.dispatch('feedback/fetchFeedbackItem', feedback.id);
        this.$store.dispatch('feedback/setSelectedFeedbackId', feedback.id);
        let index = feedback.status === 'preview' ? 0 : 1;
        let filter = {
          index: index,
          value: feedback.status,
        };
        this.$store.dispatch('feedback/setSelectedStatusTabFilter', filter);
        this.$store.dispatch('feedback/setSelectedStatusTabIndex', index);
        router.push({ path: frontendURL(path) });
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.modal-content {
  padding: 3rem;
}
</style>
