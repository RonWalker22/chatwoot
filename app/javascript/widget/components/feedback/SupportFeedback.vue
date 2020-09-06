<template>
  <div class="box">
    <h2 class="title is-6 has-text-centered">
      Support this feature
    </h2>
    <div v-if="!isSupporter">
      <div class="has-text-centered">
        <button
          class="button is-info is-small is-rounded is-outlined"
          data-target="support-modal"
          aria-haspopup="true"
          @click="openModal()"
        >
          Support
        </button>
      </div>
      <div
        id="support-modal"
        class="modal"
        :class="{ 'is-active': modalActive }"
      >
        <div class="modal-background" @click="closeModal()"></div>
        <div class="modal-card">
          <header class="modal-card-head">
            <p class="modal-card-title">
              Support This Feature
            </p>
            <button
              class="delete"
              aria-label="close"
              @click="closeModal()"
            ></button>
          </header>
          <section class="modal-card-body">
            <div class="field">
              <label class="label">
                Are you be willing to pay $25 for this feature?
              </label>
              <div class="control">
                <label class="radio">
                  <input
                    type="radio"
                    name="member"
                    @click="payload.supportLevel = 25"
                  />
                  Yes
                </label>
                <label class="radio">
                  <input
                    type="radio"
                    name="member"
                    @click="payload.supportLevel = 0"
                  />
                  No
                </label>
              </div>
            </div>

            <div class="field">
              <label class="label">Email</label>
              <div class="control">
                <input class="input" type="email" placeholder="email" />
              </div>
            </div>

            <div class="field is-grouped submit-container">
              <div class="control">
                <button class="button is-info" @click="newSupporter()">
                  Submit
                </button>
              </div>
              <div class="control">
                <button class="button" @click="closeModal()">
                  Cancel
                </button>
              </div>
            </div>
          </section>
        </div>
      </div>
    </div>
    <div v-else>
      <p>You already support this feature.</p>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  name: 'SupportFeedback',
  props: {
    fbId: {
      type: Number,
      default: 0,
    },
    supporter: {
      type: Boolean,
      deafult: false,
    },
  },
  data() {
    return {
      payload: {
        supportLevel: 0,
        details: '',
        websiteToken: window.chatwootWebChannel.websiteToken,
        feedbackId: this.fbId,
        email: '',
      },
      modalOpen: false,
    };
  },
  computed: {
    modalActive() {
      return this.modalOpen;
    },
    isSupporter() {
      return this.supporter;
    },
  },
  methods: {
    ...mapActions('feedback', ['createSupporter']),
    openModal() {
      this.modalOpen = true;
    },
    closeModal() {
      this.modalOpen = false;
    },
    newSupporter() {
      this.createSupporter(this.payload);
      // this.isSupporter = true;
      this.closeModal();
    },
  },
};
</script>

<style scoped lang="scss">
@import '~widget/assets/feedback/main.scss';

.field {
  margin-top: 2em;
}

.submit-container {
  margin-top: 3em;
}
</style>
