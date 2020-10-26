<template>
  <div>
    <transition name="modal-fade">
      <div
        v-if="show"
        class="modal-mask"
        transition="modal"
        @click="cancelModal"
      >
        <div class="modal-container" @click.stop>
          <div class="modal-content">
            <div class="row">
              <h1>New Solution</h1>
              <i
                class="ion-android-close modal--close"
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
                      @click.prevent="submitProposal"
                    >
                      Submit
                    </button>
                    <button class="button clear" @click.prevent="cancelModal">
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
    <button class="button large expanded action-button" @click="openModal">
      <i class="ion-plus-round" aria-hidden="true"> </i>
      <span class="action-text">Solution</span>
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
@import '~dashboard/assets/scss/variables';

.modal-content {
  padding: 3rem;
}

.action-button {
  background-color: transparent;
  color: $color-woot;
}

.action-text {
  display: block;
  margin-top: 0.5rem;
}

.form-item {
  margin-bottom: 4rem;
}
</style>
