<template>
  <div>
    <button
      class="button is-rounded is-small new-feature-btn is-info is-outlined"
      @click="openModal()"
    >
      <i class="icon ion-android-add" />
      <span>New</span>
    </button>
    <div
      id="feature-request-modal"
      class="modal"
      :class="{ 'is-active': modalActive }"
    >
      <div class="modal-background" @click="closeModal()"></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">
            Feedback
          </p>
          <button
            class="delete"
            aria-label="close"
            @click="closeModal()"
          ></button>
        </header>
        <section class="modal-card-body">
          <div class="field">
            <label class="label">Feedback Type</label>
            <div class="control">
              <div class="select">
                <select v-model="feedbackType">
                  <option>Feature Request</option>
                  <option>General</option>
                  <option>Bug Report</option>
                </select>
              </div>
            </div>
          </div>

          <div v-if="requestFeedback">
            <div class="field">
              <label class="label">Title</label>
              <div class="control">
                <input
                  v-model="payload.title"
                  class="input"
                  type="text"
                  placeholder="Text input"
                />
              </div>
            </div>

            <div class="field">
              <label class="label">Problem</label>
              <div class="control">
                <textarea
                  v-model="payload.problem"
                  class="textarea"
                  placeholder="Textarea"
                ></textarea>
              </div>
            </div>

            <div class="field">
              <label class="label">Solution</label>
              <div class="control">
                <textarea
                  v-model="payload.solution"
                  class="textarea"
                  placeholder="Textarea"
                ></textarea>
              </div>
            </div>
          </div>

          <div v-else class="field">
            <label class="label">Details</label>
            <div class="control">
              <textarea
                v-model="payload.details"
                class="textarea"
                placeholder="Textarea"
              ></textarea>
            </div>
          </div>

          <div class="field">
            <label class="label">Email</label>
            <div class="control">
              <input
                v-model="payload.email"
                class="input"
                type="email"
                placeholder="Email input"
                value="hello@"
              />
            </div>
            <p class="help">
              Email required if you wish to be updated on this
              {{ formatFeedbackType }}.
            </p>
          </div>

          <div class="field is-grouped submit-container">
            <div class="control">
              <button class="button is-info" @click="newFeedback()">
                Submit
              </button>
            </div>
            <div class="control">
              <button class="button is-info is-light" @click="closeModal()">
                Cancel
              </button>
            </div>
          </div>
        </section>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  data() {
    return {
      payload: {
        title: '',
        problem: '',
        solution: '',
        email: '',
        details: '',
        supportLevel: 0,
        websiteToken: window.chatwootWebChannel.websiteToken,
      },
      modalOpen: false,
      feedbackType: 'Feature Request',
    };
  },
  computed: {
    modalActive() {
      return this.modalOpen;
    },
    formatFeedbackType() {
      if (this.feedbackType === 'General') {
        return 'feedback';
      }
      return this.feedbackType.toLowerCase();
    },
    requestFeedback() {
      return this.feedbackType === 'Feature Request';
    },
  },
  methods: {
    ...mapActions('feedback', ['createFeedback']),

    openModal() {
      this.modalOpen = true;
    },
    closeModal() {
      this.modalOpen = false;
    },
    newFeedback() {
      this.createFeedback(this.payload);
      this.closeModal();
    },
  },
};
</script>

<style scoped lang="scss">
@import '~widget/assets/feedback/main.scss';

.icon {
  font-size: 130%;
}

.new-feature-btn {
  span {
    font-size: 130%;
  }
}

.submit-container {
  margin-top: 2.5em;
}
</style>
