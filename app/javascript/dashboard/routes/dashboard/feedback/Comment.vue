<template>
  <div class="callout" data-closable="slide-out-right">
    <button
      class="close-button"
      aria-label="Delete comment"
      title="Delete comment"
      type="button"
      data-close
      @click="deleteComment(post.id)"
    >
      <span aria-hidden="true">&times;</span>
    </button>
    <div class="media-object">
      <div class="media-object-section">
        <h6>{{ post.author }}</h6>
        <p>{{ post.date }}</p>
      </div>
      <div class="media-object-section">
        <p>{{ post.body }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  props: {
    post: {
      type: Object,
      required: true,
    },
    index: {
      type: [String, Number],
      require: true,
      default: 0,
    },
  },
  methods: {
    ...mapActions('feedback', ['deleteComment']),
  },
};
</script>

<style lang="scss" scoped>
@import '~dashboard/assets/scss/variables';
@import '~dashboard/assets/scss/mixins';

.media-object {
  margin-top: 2em;
  padding-bottom: 4em;
}

.callout {
  background: transparent;
  margin-bottom: 4rem;
  border: none;
  border-bottom: 1px solid rgba(0, 0, 0, 0.25);
}
</style>
