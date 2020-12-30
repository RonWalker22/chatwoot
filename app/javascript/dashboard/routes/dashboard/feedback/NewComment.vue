<template>
  <div>
    <textarea
      v-model="details"
      tabindex="0"
      placeholder="Shift + enter for new line."
      rows="3"
      data-test-id="proposal-comment-textarea"
      @keydown.enter.exact.prevent="newComment()"
    >
    </textarea>
    <button
      type="button"
      class="button"
      :disabled="details.length < 1"
      data-test-id="proposal-comment-btn"
      @click="newComment()"
    >
      add comment
    </button>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  props: {
    threadId: {
      type: [Number],
      default: 0,
    },
  },
  data() {
    return {
      details: '',
    };
  },
  methods: {
    ...mapActions('feedback', ['createComment']),
    newComment() {
      if (this.details.length > 0) {
        let payload = {
          clarification_post: {
            body: this.details,
            clarification_thread_id: this.threadId,
          },
          feedback_id: this.$route.params.feedback_id,
        };
        this.createComment({ ...payload });
        this.details = '';
      }
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~dashboard/assets/scss/variables';
textarea:focus {
  border: 2px solid $color-woot;
}
</style>
