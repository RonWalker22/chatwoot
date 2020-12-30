<template>
  <div>
    <transition name="modal-fade">
      <div
        v-if="show"
        class="modal-mask"
        transition="modal"
        data-test-id="new-solution-cancel-modal-mask"
        @click="cancelModal"
      >
        <div class="modal-container" @click.stop>
          <div class="modal-content">
            <div class="row">
              <h1 data-test-id="new-solution-title">
                New Solution
              </h1>
              <i
                class="ion-android-close modal--close"
                data-test-id="new-solution-cancel-icon"
                @click="cancelModal"
              ></i>
            </div>
            <form>
              <div class="row">
                <div class="small-12 columns">
                  <div class="form-item">
                    <textarea
                      v-model="proposal.details"
                      tabindex="0"
                      placeholder="Shift + enter for new line."
                      rows="5"
                      data-test-id="new-solution-textarea"
                      @keydown.enter.exact.prevent="submitProposal"
                    >
                    </textarea>
                  </div>
                </div>
              </div>
              <div class="modal-footer">
                <div class="medium-12 columns">
                  <div class="button-group">
                    <button
                      class="button"
                      type="submit"
                      data-test-id="new-solution-submit-btn"
                      @click.prevent="submitProposal"
                    >
                      Submit
                    </button>
                    <button
                      class="button clear"
                      data-test-id="new-solution-cancel-btn"
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
      data-test-id="new-solution-btn"
      @click="openModal"
    >
      New Solution
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
      proposal: {
        details: '',
        feedback_id: this.feedbackId,
      },
    };
  },
  methods: {
    ...mapActions('feedback', ['createSolution']),
    cancelModal() {
      this.proposal.details = '';
      this.show = false;
    },
    openModal() {
      this.show = true;
    },
    getFeedbackObject() {
      return {
        proposal: {
          details: this.proposal.details,
          feedback_id: this.feedbackId,
        },
      };
    },
    submitProposal() {
      this.createSolution(this.getFeedbackObject());
      this.cancelModal();
    },
  },
};
</script>

<style lang="scss" scoped>
.modal-content {
  padding: 3rem;
}

.form-item {
  margin-bottom: 4rem;
}
</style>
