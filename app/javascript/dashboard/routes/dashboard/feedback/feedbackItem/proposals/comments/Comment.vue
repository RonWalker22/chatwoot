<template>
  <div class="callout" data-closable="slide-out-right">
    <div class="media-object">
      <div class="media-object-section">
        <h6 data-test-id="proposal-comment-author">
          {{ post.user }}
        </h6>
      </div>
      <div class="media-object-section">
        <p data-test-id="proposal-comment-body">
          {{ post.body }}
        </p>
        <p data-test-id="proposal-comment-date">
          {{ post.date }}
        </p>
      </div>
      <div class="media-object-section more-actions-btn">
        <more-actions :id="post.id" :is-solution="false" />
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import MoreActions from '../../../MoreActions';

export default {
  components: {
    MoreActions,
  },
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
  margin-top: 1em;
  padding-bottom: 1em;
}

.callout {
  background-color: #f4f6fb;
  margin-bottom: 0;
  border: none;
  padding-right: 0;
}

.more-actions-btn {
  margin-left: auto;
}
</style>
