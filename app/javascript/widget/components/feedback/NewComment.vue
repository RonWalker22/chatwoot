<template>
  <article class="media">
    <div class="media-content">
      <div class="field">
        <p class="control">
          <textarea
            v-model="payload.details"
            class="textarea"
            placeholder="Add a comment..."
            @keydown.enter.exact.prevent="newComment()"
          ></textarea>
        </p>
      </div>
      <nav class="level submit-container">
        <div class="level-left">
          <div class="level-item">
            <button class="button is-info  is-outlined" @click="newComment()">
              add comment
            </button>
          </div>
        </div>
      </nav>
    </div>
  </article>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  name: 'NewComment',
  props: {
    fbId: {
      type: Number,
      default: 0,
    },
  },
  data() {
    return {
      payload: {
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
  },
  methods: {
    ...mapActions('feedback', ['createComment']),
    newComment() {
      if (this.payload.details.length > 0) {
        this.createComment(this.payload);
        this.payload.details = '';
      }
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~widget/assets/feedback/main.scss';

.textarea:focus {
  outline: none !important;
  border: 1px solid $ik4-color;
  box-shadow: 0 0 5px $ik4-color;
}

.submit-container {
  margin-top: 2.5em;
}
</style>
