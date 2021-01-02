<template>
  <div>
    <button
      v-if="!active"
      class="new-comment-preview button hollow"
      data-test-id="proposal-comment-preview-btn"
      @click="active = true"
    >
      reply
    </button>
    <div v-else>
      <textarea
        v-model="details"
        v-focus
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
        data-test-id="proposal-comment-submit-btn"
        @click="newComment()"
      >
        add comment
      </button>
      <button
        class="button clear"
        data-test-id="proposal-comment-cancel-btn"
        @click="(active = false), (details = '')"
      >
        Cancel
      </button>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  directives: {
    focus: {
      inserted(el) {
        el.focus();
      },
    },
  },
  props: {
    threadId: {
      type: [Number],
      default: 0,
    },
    mainBoard: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      details: '',
      active: false,
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
        this.active = false;
      }
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~dashboard/assets/scss/variables';
textarea:focus {
  border: 1px solid $color-woot;
}

textarea {
  margin-top: 1em;
}

.new-comment-preview {
  background: transparent;
  color: #3c4858;
  border-color: transparent;
  text-decoration: underline;
  &:hover {
    border-color: transparent;
    color: $color-woot;
    background: transparent;
  }
}
</style>
