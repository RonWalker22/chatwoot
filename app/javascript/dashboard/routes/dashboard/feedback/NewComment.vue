<template>
  <div>
    <textarea
      v-model="details"
      tabindex="0"
      placeholder="Shift + enter for new line."
      rows="3"
      @keydown.enter.exact.prevent="newComment()"
    >
    </textarea>
    <button
      type="button"
      class="button"
      :disabled="details.length < 1"
      @click="newComment()"
    >
      add comment
    </button>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  data() {
    return {
      details: '',
    };
  },
  methods: {
    ...mapActions('feedback', ['createComment']),
    newComment() {
      let payload = {
        clarification_post: {
          body: this.details,
        },
        feedback_id: this.$route.params.feedback_id,
      };
      this.createComment({ ...payload });
      this.details = '';
    },
  },
};
</script>
