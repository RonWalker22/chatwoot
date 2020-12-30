<template>
  <div>
    <transition name="modal-fade">
      <div
        v-if="show"
        class="modal-mask"
        transition="modal"
        data-test-id="edit-feedback-cancel-mask"
        @click="cancelModal"
      >
        <div class="modal-container" @click.stop>
          <div class="modal-content">
            <div class="row">
              <h1 data-test-id="edit-feedback-title">
                New Feedback
              </h1>
              <i
                class="ion-android-close modal--close"
                data-test-id="edit-feedback-cancel-icon"
                @click="cancelModal"
              ></i>
            </div>
            <form>
              <div class="row">
                <div class="small-12 columns">
                  <div class="form-item">
                    <label>
                      New Title
                      <input
                        v-model.trim="payload.feedback.title"
                        type="text"
                        data-test-id="edit-feedback-new-title-input"
                      />
                    </label>
                  </div>
                </div>
                <div class="small-7 columns">
                  <div class="form-item">
                    <label>
                      Change Status
                      <select
                        v-model="payload.feedback.status"
                        aria-describedby="feedbackStatusHelpText"
                        data-test-id="edit-feedback-change-status-select"
                      >
                        <option value="" selected disabled hidden>
                          Select status
                        </option>
                        <option
                          v-for="(status, index) in getStatusOptions"
                          :key="index"
                          :value="status.value"
                          :data-test-id="
                            'edit-feedback-change-status-option-' + status.value
                          "
                        >
                          {{ status.name }}
                        </option>
                      </select>
                    </label>
                    <p id="feedbackStatusHelpText" class="help-text">
                      Current status: {{ feedback.status }}
                    </p>
                  </div>
                  <div class="form-item">
                    <label>
                      Change Type
                      <select
                        v-model="payload.feedback.kind"
                        aria-describedby="feedbackTypeHelpText"
                        data-test-id="edit-feedback-change-type-select"
                      >
                        <option value="" selected disabled hidden>
                          Select type
                        </option>
                        <option
                          v-for="(kind, index) in getKindOptions"
                          :key="index"
                          :value="kind.value"
                          :data-test-id="
                            'edit-feedback-change-type-option-' + kind.value
                          "
                        >
                          {{ kind.name }}
                        </option>
                      </select>
                    </label>
                    <p id="feedbackTypeHelpText" class="help-text">
                      Current type: {{ feedback.kind }}
                    </p>
                  </div>
                </div>
              </div>
              <div class="modal-footer">
                <div class="medium-12 columns">
                  <div class="button-group">
                    <button
                      class="button"
                      type="submit"
                      data-test-id="edit-feedback-submit-btn"
                      @click.prevent="submitFeedback"
                    >
                      Submit
                    </button>
                    <button
                      class="button clear"
                      data-test-id="edit-feedback-cancel-btn"
                      @click.prevent="cancelModal"
                    >
                      Cancel
                    </button>
                  </div>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </transition>
    <button
      class="button hollow small"
      data-test-id="edit-feedback-btn"
      @click="openModal"
    >
      Edit Feedback
    </button>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  props: {
    feedbackId: {
      type: [String, Number],
      default: 0,
      required: true,
    },
  },
  data() {
    return {
      show: false,
      payload: {
        feedback: {
          title: '',
          kind: '',
          status: '',
        },
        id: this.feedbackId,
      },
      statusOptions: [
        { name: 'Review', value: 'review' },
        { name: 'Active', value: 'active' },
        { name: 'Resolved', value: 'resolved' },
      ],
      kindOptions: [
        { name: 'Feature Request', value: 'request' },
        { name: 'General', value: 'general' },
        { name: 'Bug Report', value: 'bug' },
      ],
    };
  },
  computed: {
    feedback() {
      return this.$store.getters['feedback/getFeedbackItem'](this.feedbackId);
    },
    getKindOptions() {
      return this.kindOptions.filter(option => {
        return option.value !== this.feedback.kind;
      });
    },
    getStatusOptions() {
      return this.statusOptions.filter(option => {
        return option.value !== this.feedback.status;
      });
    },
  },
  methods: {
    ...mapActions('feedback', ['updateFeedback']),
    cancelModal() {
      let feedbackKeys = Object.keys(this.payload.feedback);
      feedbackKeys.forEach(key => {
        this.payload.feedback[key] = '';
      });
      this.show = false;
    },
    openModal() {
      this.show = true;
    },
    getFeedbackObject() {
      let feedbackObj = { payload: { feedback: {} } };
      let feedbackEntries = Object.entries(this.payload.feedback);
      feedbackEntries.forEach(arr => {
        let key = arr[0];
        let value = arr[1];
        this.payload.feedback[key] = '';
        if (value && this.feedback[key] !== value) {
          feedbackObj.payload.feedback[key] = value;
        }
      });
      feedbackObj.id = this.payload.id;
      return feedbackObj;
    },
    submitFeedback() {
      this.updateFeedback(this.getFeedbackObject());
      this.cancelModal();
    },
  },
};
</script>

<style lang="scss" scoped>
.modal-content {
  padding: 3rem;
}

.action-text {
  display: block;
  margin-top: 0.5rem;
}

.form-item {
  margin-bottom: 4rem;
}
</style>
