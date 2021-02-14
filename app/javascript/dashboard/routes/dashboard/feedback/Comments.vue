<template>
  <div class="comments">
    <div v-if="show || zeroComments">
      <Comment
        v-for="(post, index) in posts"
        :key="post.id"
        :post="post"
        :index="index"
      />
      <NewComment :thread-id="threadId" />
    </div>
    <div v-else>
      <button
        class="button small hollow"
        data-test-id="comments-show-btn"
        @click="show = true"
      >
        show comments({{ posts.length }})
      </button>
    </div>
  </div>
</template>

<script>
import Comment from './Comment';
import NewComment from './NewComment';

export default {
  components: {
    Comment,
    NewComment,
  },
  props: {
    mainBoard: {
      type: Boolean,
      requried: true,
      default: false,
    },
    threadId: {
      type: Number,
      required: true,
      default: 0,
    },
    feedbackId: {
      type: Number,
      required: true,
      default: 0,
    },
  },
  data() {
    return {
      show: false,
    };
  },
  computed: {
    posts() {
      return this.$store.getters['feedback/getPosts'](
        this.feedbackId,
        this.threadId
      );
    },
    zeroComments() {
      return this.posts.length === 0;
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~dashboard/assets/scss/variables';

.comments {
  background-color: transparent;
  margin-top: 1rem;
}

.button.hollow {
  border: none;
  color: #3c4858;

  &:hover {
    color: $color-woot;
  }
}

.hide-btn {
  text-align: center;
}
</style>
