<template>
  <div>
    <transition name="modal-fade">
      <div
        v-if="show"
        class="modal-mask"
        transition="modal"
        @click="closeModal"
      >
        <div class="modal-container" @click.stop>
          <div class="modal-content">
            <div class="row">
              <h1>New Feedback</h1>
              <i class="ion-android-close modal--close" @click="closeModal"></i>
            </div>
            <form>
              <div class="row">
                <div class="small-7 columns">
                  <label>
                    Feedback Type
                    <select v-model="payload.feedback.kind">
                      <option value="" selected disabled hidden>
                        Choose Feedback Type
                      </option>
                      <option value="request">
                        Feature Request
                      </option>
                      <option value="general">
                        General
                      </option>
                      <option value="bug">
                        Bug Report
                      </option>
                    </select>
                  </label>
                  <label>
                    Inbox
                    <select v-model="payload.feedback.inbox_id">
                      <option
                        v-for="inbox in inboxList"
                        :key="inbox.id"
                        :value="inbox.id"
                      >
                        {{ inbox.name }}
                      </option>
                    </select>
                  </label>
                </div>
                <div v-if="requestFeedback" class="small-12 columns">
                  <label>
                    Title
                    <input v-model.trim="payload.feedback.title" type="text" />
                  </label>
                  <label>
                    Problem
                    <textarea v-model="payload.problem" rows="4"></textarea>
                  </label>
                  <label>
                    Solution
                    <textarea v-model="payload.solution" rows="4"></textarea>
                  </label>
                </div>
                <div v-else class="small-12 columns">
                  <label>
                    Details
                    <textarea v-model="payload.details" rows="6"></textarea>
                  </label>
                </div>
              </div>
              <div class="modal-footer">
                <div class="medium-12 columns">
                  <button
                    class="button"
                    type="submit"
                    @click.prevent="submitFeedback"
                  >
                    Submit
                  </button>
                  <button class="button clear" @click.prevent="CancelModal">
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
      @click="openModal"
    >
      New Feedback
    </woot-button>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';

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
        details: '',
      },
    };
  },
  computed: {
    requestFeedback() {
      return this.payload.feedback.kind === 'request';
    },
    ...mapGetters({
      inboxList: 'inboxes/getInboxes',
    }),
  },
  methods: {
    ...mapActions('feedback', ['createFeedback']),
    CancelModal() {
      let resetFeedback = {
        feedback: {
          title: '',
          kind: 'request',
          inbox_id: '',
        },
        problem: '',
        solution: '',
        details: '',
      };
      this.show = false;
      this.payload = resetFeedback;
    },
    closeModal() {
      this.show = false;
    },
    openModal() {
      this.show = true;
    },
    getFeedbackObject() {
      return {
        feedback: {
          title: this.payload.feedback.title,
          kind: this.payload.feedback.kind,
          inbox_id: this.payload.feedback.inbox_id,
        },
        problem: this.payload.problem,
        solution: this.payload.solution,
        details: this.payload.details,
      };
    },
    submitFeedback() {
      this.createFeedback(this.getFeedbackObject());
      this.CancelModal();
    },
  },
};
</script>

<style lang="scss" scoped>
.modal-content {
  padding: 3rem;
}
</style>
